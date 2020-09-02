import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stogether/article.dart';
import 'package:stogether/models/article.dart';
import 'package:stogether/models/comment.dart';
import 'package:stogether/models/studygroup.dart';
import 'package:stogether/models/user.dart';
import 'package:stogether/dateformat.dart';
import 'package:stogether/write.dart';
import 'package:flutter/scheduler.dart';

import 'api.dart' as api;
import 'package:stogether/data.dart' as data;
import 'package:stogether/chat.dart' as chat;

class StudygroupPage extends StatefulWidget {

  final int myNo;
  final Studygroup group;

  StudygroupPage({Key key, this.group, this.myNo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StudygroupPageState(group: group);
  }

}

class _StudygroupPageState extends State<StudygroupPage> {

  static const BOARD = 0;

  final Studygroup group;
  List<Article> articles = List<Article>();
  List<User> authors = List<User>();
  List<int> commentCounts = List<int>();
  

  _StudygroupPageState({this.group}) {
    getArticles();
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(group.name),
          bottom: TabBar(
            tabs: <Widget>[
              //Tab(text: '홈'),
              Tab(text: '게시판'),
              Tab(text: '채팅방'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            //Column(),
            Scaffold(
              body: Container(color: Colors.grey[300], child: SizedBox.expand(child: ListView.builder(
                itemCount: articles.length,
                itemBuilder: (ctx, index) {
                  var article = articles[index];
                  var author = authors[index];
                  return Card(child: Stack(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(padding: EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 6), child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: buildPictureImage(authors[index])
                                  )
                                ),
                              ),
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(author.nickname),
                                  Text(relativeDate(now, article.createdAt), style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                                  Container(height: 10),
                                  Text(article.content),
                                ],
                              ))
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          )),
                          Container(
                            padding: EdgeInsets.only(right: 12, bottom: 12),
                            child: Text('댓글 ${commentCounts[index]}개', textAlign: TextAlign.right, style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12
                            ),)
                          )
                        ]
                    ),
                    Positioned.fill(child: Material(color: Colors.transparent, child: InkWell(
                      onTap: () => showArticle(article.no),
                    )))
                  ]));
                },
              ))),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push<bool>(context, MaterialPageRoute(builder: (context) => WritePage(group: group))).then((result) {
                    if(result) {
                      getArticles();
                    }
                  });
                },
              ),
            ),
            ChatPage(group: group, myNo: widget.myNo),
          ],
        ),
      ),
    );
  }

  getArticles() async {
    var response = await api.get('/studygroups/${group.no}/articles');
    if(response.statusCode != 200) {
      return Future.value();
    }
    
    var articles = Article.fromJsonArray(response.body);
    var authors = List<User>();
    var commentCounts = List<int>();
    for(Article article in articles) {
      User user = await User.fromNo(article.author);
      authors.add(user);
      response = await api.get('/articles/${article.no}/comments');
      var comments = Comment.fromJsonArray(response.body);
      commentCounts.add(comments.length);
    }

    setState(() {
      this.articles = articles;
      this.authors = authors;
      this.commentCounts = commentCounts;
    });
  }

  showArticle(int no) async {
    Article article = await Article.fromNo(no);
    List<int> userNos = List<int>();
    userNos.add(article.author);

    var response = await api.get('/articles/${article.no}/comments');
    if(response.statusCode != 200) {
      return;
    }

    List<Comment> comments = Comment.fromJsonArray(response.body);
    for(Comment comment in comments) {
      if(!userNos.contains(comment.author))
        userNos.add(comment.author);
    }

    Map<int, User> users = Map<int, User>();
    for(int no in userNos) {
      User user = await User.fromNo(no);
      users[no] = user;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => ArticlePage(title: group.name, article: article, comments: comments, users: users)));
  }

  /*Widget buildFAB(BuildContext context) {
    if(DefaultTabController.of(context).index != BOARD)
      return null;

    return FloatingActionButton(
      child: Icon(Icons.edit),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => WritePage(group: group)));
      },
    );
  }*/

}

class ChatPage extends StatefulWidget {

  final int myNo;
  final Studygroup group;

  ChatPage({Key key, this.group, this.myNo}) : super(key: key);
  
  @override
  _ChatPageState createState() {
    
    return _ChatPageState(group);
  }

}

class _ChatPageState extends State<ChatPage> {

  final scroll = ScrollController();
  final messageInput = TextEditingController();

  Studygroup group;
  List<int> talkers = List<int>();
  List<String> messages = List<String>();
  Map<int, User> users = Map<int, User>();

  _ChatPageState(this.group) {
    chat.connect(token: data.main.token, group: group.no, onChat: onChat);
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.grey[300], child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Flexible(child: ListView.builder(
          itemCount: talkers.length,
          itemBuilder: (BuildContext context, int index) {
            User talker = users[talkers[index]];
            String message = messages[index];

            if(talker.no == widget.myNo)
              return Container(padding: EdgeInsets.only(top: 10, bottom: 10),child: _MyBubble(message: message));
            return Container(padding: EdgeInsets.only(top: 10, bottom: 10),child: _ReceivedSpeech(user: talker, message: message));
          },
          scrollDirection: Axis.vertical,
          controller: scroll,
        )),
        Container(height: 48, color: Colors.white, child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 10),
            Expanded(child: TextField (
              controller: messageInput,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 6),
                hintText: '대화 입력',
              ),
            )),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.send, size: 30, color: Theme.of(context).primaryColor),
              onPressed: () {
                chat.channel.sink.add(json.encode({
                  "cmd": "chat",
                  "data": messageInput.text,
                }));
                messageInput.clear();
              },
            ),
            SizedBox(width: 10),
          ]
        ))
      ]),
    );
  }

  onChat(int talker, String message) async {
    if(!users.containsKey(talker)) {
      users[talker] = await User.fromNo(talker);
    }

    setState(() {
      talkers.add(talker);
      messages.add(message);

      SchedulerBinding.instance.addPostFrameCallback((_) {
        scroll.animateTo(scroll.position.maxScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.easeOut);
      });
    });
  }

}

class _ReceivedSpeech extends StatelessWidget {

  final User user;
  final String message;

  _ReceivedSpeech({Key key, this.user, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          margin: EdgeInsets.only(left: 10, right: 5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: buildPictureImage(user),
            )
          ),
        ),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(user.nickname),
            _Bubble(message: message)
          ],
        ))
      ],
    );
  }

}

class _Bubble extends StatelessWidget {

  final String message;

  _Bubble({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Image.asset('assets/bubble_tail.png', scale: 4),
        Flexible(child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
            color: Colors.white
          ),
          child: Text(message),
        )),
        Container(width: 100)
      ],
    );
  }

}

class _MyBubble extends StatelessWidget {

  final String message;

  _MyBubble({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(width: 100),
        Flexible(child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
            color: Colors.white
          ),
          child: Text(message),
        )),
        Image.asset('assets/my_bubble_tail.png', scale: 4),
        Container(width: 5,),
      ],
    );
  }

}

buildPictureImage(User user) {
  if(user == null || user.picture == null || user.picture.isEmpty)
    return AssetImage('assets/no_picture.png');
  else
    return NetworkImage(api.SERVER_URL + user.picture);
}
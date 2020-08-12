import 'package:flutter/material.dart';
import 'package:stogether/article.dart';
import 'package:stogether/models/article.dart';
import 'package:stogether/models/comment.dart';
import 'package:stogether/models/studygroup.dart';
import 'package:stogether/models/user.dart';
import 'package:stogether/dateformat.dart';
import 'package:stogether/write.dart';

import 'api.dart' as api;

class StudygroupPage extends StatefulWidget {

  final Studygroup group;

  StudygroupPage({Key key, this.group}) : super(key: key);

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
                                    image: NetworkImage('https://i.stack.imgur.com/34AD2.jpg')
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
            ChatPage(),
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
  
  @override
  _ChatPageState createState() {
    
    return _ChatPageState();
  }

}

class _ChatPageState extends State<ChatPage> {
  
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.grey[500], child: Column(
      children: <Widget>[
        Text('gdgdg'),
        _ReceivedSpeech(nickname: '마수현', message: '나랏말싸미 듕귁에 달아 문자와로 서로 사맛디 아니할세'),
        Text('gdgdg'),
        
      ],
    ));
  }

}

class _ReceivedSpeech extends StatelessWidget {

  final String nickname;
  final String message;

  _ReceivedSpeech({Key key, this.nickname, this.message}) : super(key: key);

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
              image: NetworkImage('https://i.stack.imgur.com/34AD2.jpg')
            )
          ),
        ),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(nickname),
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
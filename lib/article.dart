import 'package:flutter/material.dart';
import 'package:stogether/dateformat.dart';
import 'package:stogether/models/article.dart';
import 'package:stogether/models/comment.dart';
import 'package:stogether/models/user.dart';
import 'package:flutter/scheduler.dart';

import 'package:stogether/api.dart' as api;
import 'package:stogether/data.dart' as data;

class ArticlePage extends StatefulWidget {

  final String title;
  final Article article;
  final List<Comment> comments;
  final Map<int, User> users;

  ArticlePage({Key key, this.title, this.article, this.comments, this.users}) : super(key: key);
  
  @override
  _ArticlePageState createState() => _ArticlePageState(article: article, comments: comments, users: users);

}

class _ArticlePageState extends State<ArticlePage> {

  final scroll = ScrollController();
  final commentContent = TextEditingController();

  Article article;
  List<Comment> comments;
  Map<int, User> users;

  _ArticlePageState({this.article, this.comments, this.users});
  
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(child: SingleChildScrollView(
            controller: scroll,
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Container(padding: EdgeInsets.all(12), color: Colors.white, child: Row(
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
                        Text(users[article.author].nickname),
                        Text(relativeDate(now, article.createdAt), style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                        Container(height: 10),
                        Text(article.content),
                      ],
                    ))
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                )),
                Divider(height: 0)
              ]..addAll(buildComments(context, now))
            ),
          )),
          Container(
            height: 50,
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 10),
                Expanded(child: TextField (
                  controller: commentContent,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 6),
                    hintText: '댓글 입력',
                  ),
                )),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.send, size: 30, color: Theme.of(context).primaryColor),
                  onPressed: postComment,
                ),
                SizedBox(width: 10),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Widget> buildComments(BuildContext context, DateTime now) {
    List<Widget> result = [];

    for(Comment comment in comments) {
      result.add(Divider(height: 0));
      result.add(Container(padding: EdgeInsets.all(12), child: Row(
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
              Text(users[comment.author].nickname),
              Text(relativeDate(now, comment.createdAt), style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              Container(height: 10),
              Text(comment.content),
            ],
          ))
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      )));
    }

    return result;
  }

  Future<void> refreshData() async {
    Article article = await Article.fromNo(this.article.no);
    var response = await api.get('/articles/${article.no}/comments');
    List<Comment> comments = Comment.fromJsonArray(response.body);
    
    List<int> userNos = List<int>();
    userNos.add(article.author);
    for(Comment comment in comments) {
      if(!userNos.contains(comment.author))
        userNos.add(comment.author);
    }

    Map<int, User> users = Map<int, User>();
    for(int no in userNos) {
      User user = await User.fromNo(no);
      users[no] = user;
    }

    this.setState(() {
      this.article = article;
      this.comments = comments;
      this.users = users;

      SchedulerBinding.instance.addPostFrameCallback((_) {
        scroll.animateTo(scroll.position.maxScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.easeOut);
      });
      
    });

    return Future.value();
  }

  postComment() {
    api.post('/comments', headers: {
      'Authorization': 'Bearer ${data.main.token}'
    }, body: {
      "article": article.no,
      "content": commentContent.text
    }).then((response) {
      if(response.statusCode == 200) {
        refreshData();
      }
    });
    commentContent.clear();
  }

}
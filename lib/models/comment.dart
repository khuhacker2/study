import 'dart:convert';

import 'package:stogether/api.dart' as api;

class Comment {

  int no;
  int article;
  int author;
  String content;
  DateTime createdAt;

  Comment({this.no, this.article, this.author, this.content, this.createdAt});

  static Comment fromJson(String jsonData) {
    var obj = json.decode(jsonData);
    return Comment(no: obj['no'], article: obj['article'],
                    author: obj['author'], content: obj['content'], createdAt: DateTime.parse(obj['created_at']));
  }

  static List<Comment> fromJsonArray(String jsonData) {
    List<Comment> groups = List<Comment>();
    var arr = json.decode(jsonData);
    arr.forEach((obj) => groups.add(Comment(no: obj['no'], article: obj['article'],
                    author: obj['author'], content: obj['content'], createdAt: DateTime.parse(obj['created_at']))));
    return groups;
  }

  static Future<Comment> fromNo(int no) async {
    var response = await api.get('/comments/$no');
    if(response.statusCode == 200) {
      return Future.value(Comment.fromJson(response.body));
    }
    else {
      return Future.error('Not Found');
    }
  }

}
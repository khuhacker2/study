import 'dart:convert';

import 'package:stogether/api.dart' as api;

class Article {
  
  int no;
  int studygroup;
  int author;
  String title;
  String content;
  DateTime createdAt;

  Article({this.no, this.studygroup, this.author, this.title, this.content, this.createdAt});

  static Article fromJson(String jsonData) {
    var obj = json.decode(jsonData);
    return Article(no: obj['no'], studygroup: obj['studygroup'],
                    author: obj['author'], title: obj["title"], content: obj['content'], createdAt: DateTime.parse(obj['created_at']));
  }

  static List<Article> fromJsonArray(String jsonData) {
    List<Article> groups = List<Article>();
    var arr = json.decode(jsonData);
    arr.forEach((obj) => groups.add(Article(no: obj['no'], studygroup: obj['studygroup'],
                    author: obj['author'], title: obj["title"], content: obj['content'], createdAt: DateTime.parse(obj['created_at']))));
    return groups;
  }

  static Future<Article> fromNo(int no) async {
    var response = await api.get('/articles/$no');
    if(response.statusCode == 200) {
      return Future.value(Article.fromJson(response.body));
    }
    else {
      return Future.error('Not Found');
    }
  }

}
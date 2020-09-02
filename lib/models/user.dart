import 'dart:convert';

import 'package:stogether/api.dart' as api;

class User {

  int no;
  String id;
  String nickname;
  String picture;

  User({this.no, this.id, this.nickname, this.picture});

  static User fromJson(String jsonData) {
    var obj = json.decode(jsonData);
    return User(no: obj['no'], id: obj['id'], nickname: obj['nickname'], picture: obj['picture']);
  }

  static Future<User> fromNo(int no) async {
    var response = await api.get('/users/$no');
    if(response.statusCode == 200) {
      return Future.value(User.fromJson(response.body));
    }
    else {
      return Future.error('Not Found');
    }
  }

}


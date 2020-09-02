import 'dart:convert';
import 'package:stogether/api.dart' as api;

class Studygroup {

  int no;
  int category;
  String name;
  String description;
  String image;

  Studygroup({this.no, this.category, this.name, this.description, this.image});

  static Studygroup fromJson(String jsonData) {
    var obj = json.decode(jsonData);
    return Studygroup(no: obj['no'], category: obj['category'], name: obj['name'], description: obj["description"], image: obj["image"]);
  }

  static List<Studygroup> fromJsonArray(String jsonData) {
    List<Studygroup> groups = List<Studygroup>();
    var arr = json.decode(jsonData);
    arr.forEach((obj) => groups.add(Studygroup(no: obj['no'], category: obj['category'], name: obj['name'], description: obj["description"], image: obj["image"])));
    return groups;
  }

  static Future<Studygroup> fromNo(int no) async {
    var response = await api.get('/studygroups/$no');
    if(response.statusCode == 200) {
      return Future.value(Studygroup.fromJson(response.body));
    }
    else {
      return Future.error('Not Found');
    }
  }

}
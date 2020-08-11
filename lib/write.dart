import 'package:flutter/material.dart';
import 'package:stogether/models/studygroup.dart';
import 'package:stogether/api.dart' as api;
import 'package:stogether/data.dart' as data;

class WritePage extends StatelessWidget {

  final title = TextEditingController();
  final content = TextEditingController();

  final Studygroup group;

  WritePage({Key key, this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              api.post('/articles', headers: {
                'Authorization': 'Bearer ${data.main.token}'
              }, body: {
                'studygroup': group.no,
                'title': title.text,
                'content': content.text
              }).then((response) {
                if(response.statusCode == 200) {
                  Navigator.pop(context, true);
                }
              });
            },
          )
        ],
      ),
      body: Container(padding: EdgeInsets.all(10), child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: title,
            decoration: InputDecoration(
              labelText: '제목',
              contentPadding: EdgeInsets.only(bottom: 5)
            ),
            style: TextStyle(
              fontSize: 16,
              color: Colors.black
            ),
          ),
          Container(height: 10),
          TextField(
            controller: content,
            decoration: InputDecoration(
              labelText: '내용',
              contentPadding: EdgeInsets.only(bottom: 5)
            ),
            style: TextStyle(
              fontSize: 16,
              color: Colors.black
            ),
            maxLines: null,
          )
        ],
      )),
    );
  }

}
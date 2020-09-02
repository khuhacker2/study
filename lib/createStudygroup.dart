import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'api.dart' as api;
import 'data.dart' as data;

class CreateStudygroup extends StatefulWidget {
  
  final imagePicker = ImagePicker();

  @override
  CreateStudygroupState createState() {
    return CreateStudygroupState();
  }

}

class CreateStudygroupState extends State<CreateStudygroup> {

  int _selectedCategory;
  String _imageUrl = '';
  final name = TextEditingController();
  final description = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('스터디그룹 생성'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: postStudygroup,
          )
        ],
      ),
      body: Container(padding: EdgeInsets.all(12), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DropdownButton<int> (
            value: _selectedCategory,
            hint: Text('카테고리'),
            items: [
              DropdownMenuItem(value: 0, child: Text('대학진학')),
              DropdownMenuItem(value: 1, child: Text('취업')),
              DropdownMenuItem(value: 2, child: Text('프로그래밍')),
            ],
            onChanged: (item) {
              setState(() {
                _selectedCategory = item;      
              });
            },
          ),
          TextField(
            decoration: InputDecoration(
              labelText: '스터디그룹 이름',
              contentPadding: EdgeInsets.only(bottom: 5)
            ),
            style: TextStyle(
              fontSize: 16,
              color: Colors.black
            ),
            controller: name,
          ),
          Container(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: '스터디그룹 설명',
              contentPadding: EdgeInsets.only(bottom: 5)
            ),
            style: TextStyle(
              fontSize: 16,
              color: Colors.black
            ),
            maxLines: null,
            controller: description,
          ),
          Container(height: 10),
          GestureDetector(
            onTap: () async {
              final file = await widget.imagePicker.getImage(source: ImageSource.gallery);
              final ext = file.path.split('.').last;
              var type = '';

              if(ext == 'png')
                type = 'image/png';
              else if(ext == 'jpg' || ext == 'jpeg')
                type = 'image/jpeg';
              
              final res = await api.post('/images', headers: {
                "authorization": "Bearer " + data.main.token,
                "Content-Type": type
              }, body: await file.readAsBytes(), rawBody: true);

              setState(() {
                _imageUrl = json.decode(res.body)['path'];      
              });
            },
            child: buildImage(),
          )
        ],
      ),
    ));
  }

  buildImage() {
    if(_imageUrl.isEmpty)
      return Image.asset("assets/no_image.png", width: 100, height: 100, fit: BoxFit.fill);
    else
      return Image.network(api.SERVER_URL + _imageUrl, width: 100, height: 100, fit: BoxFit.fill);
  }

  postStudygroup() {
    api.post('/studygroups', headers: {
      "authorization": "Bearer " + data.main.token
    }, body: {
      "category": _selectedCategory,
      "name": name.text,
      "description": description.text,
      "image": _imageUrl
    }).then((response) {
      if(response.statusCode == 200) {
        Navigator.pop(context);
      }
    });
  }

}
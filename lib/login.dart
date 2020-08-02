import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stogether/register.dart';
import 'api.dart' as api;
import 'data.dart' as data;

class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }

}

class _LoginPageState extends State<LoginPage> {

  final id = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.white, hintColor: Colors.grey[300]),
      child: Scaffold(
        backgroundColor: Colors.redAccent[700],
        body: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(70, 0, 70, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    labelText: '아이디',
                    contentPadding: EdgeInsets.only(bottom: 5, top: 5)
                  ),
                  style: TextStyle(
                    fontSize: 16
                  ),
                  controller: id,
                ),
                Container(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    contentPadding: EdgeInsets.only(bottom: 5)
                  ),
                  style: TextStyle(
                    fontSize: 16
                  ),
                  obscureText: true,
                  controller: password,
                ),
                Container(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text('로그인', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    color: Colors.redAccent[200],
                    onPressed: login,
                  )
                ),
                Container(height: 30),
                Text('회원이 아니신가요?', style: TextStyle(color: Colors.white)),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text('회원가입', style: TextStyle(color: Colors.redAccent[700], fontWeight: FontWeight.bold)),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                    },
                  )
                ),
                /*Text('Facebook 계정이 있으신가요?', style: TextStyle(color: Colors.white)),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Row(
                      children: <Widget>[
                        Image(image: AssetImage('assets/flogo.png'), width: 20, height: 20),
                        Flexible(
                          child: Container(
                            child: Text('Facebook으로 로그인', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            alignment: Alignment.center,
                          ),
                          flex: 1,
                        )
                      ]
                    ),
                    color: Colors.indigo[600],
                    onPressed: () => {},
                  )
                ),*/
              ]
            ),
          ),
        ),
      )
    );
  }

  login() {
    api.post('/token', body: {
      "id": id.text,
      "password": password.text
    }).then((response) {
      if(response.statusCode == 200) {
        final result = json.decode(response.body);
        data.main.token = result['token'];
        data.saveData().then((v) {
          Navigator.pushReplacementNamed(context, '/');
        });
      }
      else {
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            title: Text('로그인 실패'),
            content: Text('아이디 또는 비밀번호를 확인해주세요.'),
            actions: <Widget>[
              FlatButton(child: Text('확인'), onPressed: () => Navigator.of(context).pop())
            ],
          );
        });
      }
    });
  }

}
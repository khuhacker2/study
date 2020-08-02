import 'package:flutter/material.dart';
import 'package:stogether/main.dart';
import 'api.dart' as api;

class RegisterPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }

}

class RegisterPageState extends State<RegisterPage> {

final idController = TextEditingController();
  final pwController = TextEditingController();
  final pwCheckController = TextEditingController();
  final nicknameController = TextEditingController();

  
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.white, hintColor: Colors.grey[300]),
      child: Scaffold(
        backgroundColor: Colors.redAccent[700],
        body: Stack(
          children: <Widget>[
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            Center(
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
                      controller: idController,
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
                      controller: pwController,
                    ),
                    Container(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: '비밀번호 확인',
                        contentPadding: EdgeInsets.only(bottom: 5)
                      ),
                      style: TextStyle(
                        fontSize: 16
                      ),
                      obscureText: true,
                      controller: pwCheckController,
                    ),
                    Container(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: '닉네임',
                        contentPadding: EdgeInsets.only(bottom: 5)
                      ),
                      style: TextStyle(
                        fontSize: 16
                      ),
                      controller: nicknameController,
                    ),
                    Container(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        child: Text('회원가입', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        color: Colors.redAccent[200],
                        onPressed: () {
                          if(pwController.text != pwCheckController.text) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('오류'),
                                  content: Text('비밀번호 확인이 일치하지 않습니다!'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('확인'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              }
                            );

                            return;
                          }
                          api.post('/users', body: {
                            "id": idController.text,
                            "password": pwController.text,
                            "nickname": nicknameController.text,
                          }).then((response) {
                            if(response.statusCode == 200) {
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(context, '/home');
                            }
                          });
                        },
                      )
                    ),
                  ]
                ),
              ),
            )
          ]
        ),
      )
    );
  }

}
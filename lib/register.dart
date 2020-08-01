import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  
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
                    ),
                    Container(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        child: Text('회원가입', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        color: Colors.redAccent[200],
                        onPressed: () => {},
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
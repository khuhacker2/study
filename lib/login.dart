import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  
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
                Container(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text('로그인', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    color: Colors.redAccent[200],
                    onPressed: () => {},
                  )
                ),
                Container(height: 30),
                Text('회원이 아니신가요?', style: TextStyle(color: Colors.white)),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text('회원가입', style: TextStyle(color: Colors.redAccent[700], fontWeight: FontWeight.bold)),
                    color: Colors.white,
                    onPressed: () => {},
                  )
                ),
                Text('Facebook 계정이 있으신가요?', style: TextStyle(color: Colors.white)),
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
                ),
              ]
            ),
          ),
        ),
      )
    );
  }

}
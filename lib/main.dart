import 'package:flutter/material.dart';
import 'package:stogether/createStudygroup.dart';
import 'package:stogether/login.dart';
import 'package:stogether/studygroup.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.redAccent[700],
        accentColor: Colors.redAccent[700],
        canvasColor: Colors.white,
        hintColor: Colors.grey[500]
      ),
      home: MyHomePage(title: '스투게더'),
      //home: LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final int HOME = 0;
  final int STUDYGROUP = 1;
  final int MYPAGE = 2;

  int _counter = 0;
  int _currentPage = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(primaryTextTheme: TextTheme(title: TextStyle(
        color: Colors.black
      ))),
      child: Scaffold(
        backgroundColor: getBackgroundColor(),
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          centerTitle: false,
        ),
        body: buildBody(context),
        floatingActionButton: buildFAB(context),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("홈")),
            BottomNavigationBarItem(icon: Icon(Icons.group), title: Text("스터디그룹")),
            BottomNavigationBarItem(icon: Icon(Icons.person), title: Text("마이페이지")),
          ],
          onTap: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          currentIndex: _currentPage,
        ),
      )
    );
  }

  Color getBackgroundColor() {
    if(_currentPage == STUDYGROUP || _currentPage == HOME)
      return Colors.grey[300];
    
    return Colors.white;
  }

  Widget buildFAB(BuildContext context) {
    if(_currentPage == STUDYGROUP) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateStudygroup()));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      );
    }

    return null;
  }

  Widget buildBody(BuildContext context) {
    if(_currentPage == STUDYGROUP)
      return buildStudygroup(context);
    else if(_currentPage == MYPAGE)
      return buildMyPage(context);
    else
      return buildHome(context);
  }

  Widget buildHome(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(padding: EdgeInsets.all(10), child: Text('나의 스터디그룹')),
              Container(height: 150, child: ListView.builder(
                itemCount: 100,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(width: 120, height: 120, child: Stack(
                    children: <Widget>[
                      Positioned.fill(child: Column(
                        children: <Widget>[
                          Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTF7Q8uVAHz_rPqFiY1vfQrKXTtRsZnAV92N30IG0IkPfeV0BUC', width: 100, height: 100, fit: BoxFit.fill,),
                          Text('코딩클럽')
                        ],
                      )),
                      Positioned.fill(child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Studygroup(group: {'title': '코딩클럽'},)));
                          },
                        )),
                      ),
                    ],
                  ));
                },
                scrollDirection: Axis.horizontal,
              ))
            ]
          ),
        ),
        /*Card(
          child: Column(children: <Widget>[
            Text('가장 활발한 스터디그룹')
          ]),
        ),*/
      ],
    );
  }

  Widget buildStudygroup(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(padding: EdgeInsets.all(10), child: Text('최고 인기 스터디그룹')),
              Container(height: 150, child: ListView.builder(
                itemCount: 100,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(width: 120, height: 120, child: Stack(
                    children: <Widget>[
                      Positioned.fill(child: Column(
                        children: <Widget>[
                          Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTF7Q8uVAHz_rPqFiY1vfQrKXTtRsZnAV92N30IG0IkPfeV0BUC', width: 100, height: 100, fit: BoxFit.fill,),
                          Text('코딩클럽')
                        ],
                      )),
                      Positioned.fill(child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Studygroup(group: {'title': '코딩클럽'},)));
                          },
                        )),
                      ),
                    ],
                  ));
                },
                scrollDirection: Axis.horizontal,
              ))
            ]
          ),
        ),
        /*Card(
          child: Column(children: <Widget>[
            Text('가장 활발한 스터디그룹')
          ]),
        ),*/
      ],
    );
  }

  Widget buildMyPage(BuildContext context) {
    return Container(padding: EdgeInsets.all(10), child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text('마수현님', style: TextStyle(fontSize: 18)),
            Container(
              width: 70,
              height: 70,
              margin: EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage('https://i.stack.imgur.com/34AD2.jpg')
                )
              ),
            )
          ]
        ),
        RaisedButton(
          child: Text('로그아웃'),
          onPressed: () {

          },
        )
      ],
    ));
  }
}

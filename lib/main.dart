import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stogether/createStudygroup.dart';
import 'package:stogether/login.dart';
import 'package:stogether/models/studygroup.dart';
import 'package:stogether/studygroup.dart';
import 'package:stogether/models/user.dart';
import 'package:stogether/api.dart' as api;
import 'data.dart' as data;

var rootData = {};

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  data.loadData().then((v) {
    if(data.main.token == null || data.main.token.isEmpty) {
      runApp(MyApp(initialRoute: '/login'));
    }
    else {
      getData().then((v) {
        runApp(MyApp(initialRoute: '/'));
      });
    }
  });
}

Future<void> getData() async {
  var encodedClaims = data.main.token.split('.')[1];
  while(encodedClaims.length % 4 != 0) {
    encodedClaims += '=';
  }
  var claims = String.fromCharCodes(base64.decode(encodedClaims));
  var claimsObj = json.decode(claims);
  rootData['user'] = await User.fromNo(claimsObj['no']);
  var response = await api.get('/me/studygroups', headers: {'Authorization': 'Bearer ${data.main.token}'});
  rootData['myGroups'] = Studygroup.fromJsonArray(response.body);

  return Future.value();
}

class MyApp extends StatelessWidget {

  final String initialRoute;

  MyApp({Key key, this.initialRoute}) : super(key: key);

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
      //home: MyHomePage(title: '스투게더'),
      initialRoute: initialRoute,
      routes: <String, WidgetBuilder>{
        '/': (context) => MyHomePage(title: '스투게더'),
        '/login': (context) => LoginPage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final imagePicker = ImagePicker();

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState(user: rootData['user'], groups: rootData['myGroups']);
}

class _MyHomePageState extends State<MyHomePage> {

  final int HOME = 0;
  final int STUDYGROUP = 1;
  final int MYPAGE = 2;

  int _currentPage = 0;
  User user;
  List<Studygroup> groups = List<Studygroup>();
  List<Studygroup> rank = List<Studygroup>();

  _MyHomePageState({this.user, this.groups});

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
            if(index == HOME)
              updateGroups();

            if(index == STUDYGROUP)
              updateRank();

            if(index == MYPAGE)
              updateUser();
            setState(() {
              _currentPage = index;
            });
          },
          currentIndex: _currentPage,
        ),
      )
    );
  }

  updateGroups() {
    api.get('/me/studygroups', headers: {'Authorization': 'Bearer ${data.main.token}'}).then((response) {
      rootData['myGroups'] = Studygroup.fromJsonArray(response.body);

      setState(() {
        groups = rootData['myGroups'];
      });
    });
  }

  updateRank() {
    api.get('/studygroups/rank', headers: {'Authorization': 'Bearer ${data.main.token}'}).then((response) {
      var rank = Studygroup.fromJsonArray(response.body);

      setState(() {
        this.rank = rank;
      });
    });
  }

  updateUser() {
    User.fromNo(rootData['user'].no).then((user) {
      rootData['user'] = user;
      setState(() {
         this.user = user;     
      });
    });
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
                itemCount: groups.length,
                itemBuilder: (BuildContext context, int index) {
                  Studygroup group = groups[index];
                  return SizedBox(width: 120, height: 120, child: Stack(
                    children: <Widget>[
                      Positioned.fill(child: Column(
                        children: <Widget>[
                          buildStudyImage(group),
                          Text(group.name)
                        ],
                      )),
                      Positioned.fill(child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => showStudygroup(group),
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
                itemCount: rank.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(width: 120, height: 120, child: Stack(
                    children: <Widget>[
                      Positioned.fill(child: Column(
                        children: <Widget>[
                          buildStudyImage(rank[index]),
                          Text(rank[index].name)
                        ],
                      )),
                      Positioned.fill(child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => StudygroupPage(group: {'title': '코딩클럽'},)));
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
            Text('${user.nickname}님', style: TextStyle(fontSize: 18)),
            GestureDetector(
              child: Container(
                width: 70,
                height: 70,
                margin: EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: buildPictureImage()
                  ),
                ),
              ),
              onTap: () async {
                final file = await widget.imagePicker.getImage(source: ImageSource.gallery);
                final ext = file.path.split('.').last;
                var type = '';

                if(ext == 'png')
                  type = 'image/png';
                else if(ext == 'jpg' || ext == 'jpeg')
                  type = 'image/jpeg';
                
                var res = await api.post('/images', headers: {
                  "authorization": "Bearer " + data.main.token,
                  "Content-Type": type
                }, body: await file.readAsBytes(), rawBody: true);

                res = await api.put('/me', headers: {
                  "authorization": "Bearer " + data.main.token,
                }, body: {'picture': json.decode(res.body)['path']});

                rootData['user'] = User.fromJson(res.body);
                setState(() {
                  this.user = rootData['user'];
                });
              },
            )
          ]
        ),
        RaisedButton(
          child: Text('로그아웃'),
          onPressed: () {
            data.main.token = null;
            data.saveData().then((v) {
              Navigator.of(context).pushReplacementNamed('/login');
            });
          },
        )
      ],
    ));
  }

  buildStudyImage(Studygroup group) {
    if(group.image == null || group.image.isEmpty)
      return Image.asset('assets/no_image.png', width: 100, height: 100, fit: BoxFit.fill);
    else
      return Image.network(api.SERVER_URL + group.image, width: 100, height: 100, fit: BoxFit.fill);
  }

  buildPictureImage() {
    if(user == null || user.picture == null || user.picture.isEmpty)
      return AssetImage('assets/no_picture.png');
    else
      return NetworkImage(api.SERVER_URL + user.picture);
  }

  showStudygroup(group) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => StudygroupPage(group: group, myNo: user.no,)));
  }
}

import 'package:flutter/material.dart';
import 'package:stogether/article.dart';

class StudygroupPage extends StatelessWidget {

  final group;

  StudygroupPage({Key key, this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(group['title']),
          bottom: TabBar(
            tabs: <Widget>[
              //Tab(text: '홈'),
              Tab(text: '게시판'),
              Tab(text: '채팅방'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            //Column(),
            Container(color: Colors.grey[300], child: SizedBox.expand(child: ListView.builder(
              itemCount: 20,
              itemBuilder: (ctx, index) {
                return Card(child: Stack(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(padding: EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 6), child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage('https://i.stack.imgur.com/34AD2.jpg')
                                )
                              ),
                            ),
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('마수현'),
                                Text('17분 전', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                                Container(height: 10),
                                Text('오늘의 공부법\n사실 공부하는데 있어서 유명한 공부법을 따라하는 것은 중요하지 않습니다. 누구나 자신에게 맞는 공부법이 있고 맞지 않는 공부법이 있기 때문이죠. 그렇다면 자신에게 맞는 공부법을 찾는 것이 중요합니다. 자신에게 맞는 공부법을 찾기 위해서는 최소한의 지능이 있어야합니다. 결론은 공부를 잘하기 위해서는 타고나야합니다.'),
                              ],
                            ))
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        )),
                        Container(
                          padding: EdgeInsets.only(right: 12, bottom: 12),
                          child: Text('댓글 5개', textAlign: TextAlign.right, style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12
                          ),)
                        )
                      ]
                  ),
                  Positioned.fill(child: Material(color: Colors.transparent, child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Article(title: group['title'])));
                    },
                  )))
                ]));
              },
            ))),
            ChatPage(),
          ],
        ),
      ),
    );
  }

}

class ChatPage extends StatefulWidget {
  
  @override
  _ChatPageState createState() {
    
    return _ChatPageState();
  }

}

class _ChatPageState extends State<ChatPage> {
  
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.grey[500], child: Column(
      children: <Widget>[
        Text('gdgdg'),
        _ReceivedSpeech(nickname: '마수현', message: '나랏말싸미 듕귁에 달아 문자와로 서로 사맛디 아니할세'),
        Text('gdgdg'),
        
      ],
    ));
  }

}

class _ReceivedSpeech extends StatelessWidget {

  final String nickname;
  final String message;

  _ReceivedSpeech({Key key, this.nickname, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          margin: EdgeInsets.only(left: 10, right: 5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage('https://i.stack.imgur.com/34AD2.jpg')
            )
          ),
        ),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(nickname),
            _Bubble(message: message)
          ],
        ))
      ],
    );
  }

}

class _Bubble extends StatelessWidget {

  final String message;

  _Bubble({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Image.asset('assets/bubble_tail.png', scale: 4),
        Flexible(child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
            color: Colors.white
          ),
          child: Text(message),
        )),
        Container(width: 100)
      ],
    );
  }

}
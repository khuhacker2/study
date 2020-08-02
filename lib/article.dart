import 'package:flutter/material.dart';

class Article extends StatefulWidget {

  final String title;

  Article({Key key, this.title}) : super(key: key);
  
  @override
  _ArticleState createState() => _ArticleState();

}

class _ArticleState extends State<Article> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Container(padding: EdgeInsets.all(12), color: Colors.white, child: Row(
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
                Divider(height: 0)
              ]..addAll(buildComments(context))
            ),
          )),
          Container(
            height: 50,
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 10),
                Expanded(child: TextField (
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 6),
                    hintText: '댓글 입력',
                  ),
                )),
                SizedBox(width: 10),
                Icon(Icons.send, size: 30, color: Theme.of(context).primaryColor),
                SizedBox(width: 10),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Widget> buildComments(BuildContext context) {
    List<Widget> result = [];

    for(int i = 0; i < 10; i++) {
      result.add(Divider(height: 0));
      result.add(Container(padding: EdgeInsets.all(12), child: Row(
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
              Text('팩트를 말하시다니 정말 비겁하십니다.'),
            ],
          ))
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      )));
    }

    return result;
  }

}


import 'dart:convert';

import 'package:web_socket_channel/io.dart';
import 'data.dart' as data;

IOWebSocketChannel channel;

connect({
  void onChat(int talker, String message),
  String token,
  int group
}) {
  channel = IOWebSocketChannel.connect("ws://192.168.75.231:8080/ws");
  channel.stream.listen((message) {
    print(message);
    var data = json.decode(message);
    String cmd = data["cmd"];
    switch(cmd) {
      case 'chat':
        if(onChat != null)
          onChat(data["data"]["user"], data["data"]["message"]);
        break;
      case 'sign':
        channel.sink.add(json.encode({
          "cmd": "join",
          "data": group
        }));
        break;
    }
  });
  channel.sink.add(json.encode({
    "cmd": "sign",
    "data": token
  }));
}
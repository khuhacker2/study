import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
//import 'dartson';

class Data {

  String token;

  Data({this.token});

}

Data main;

Future<void> loadData() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/data.json');
  if(file.existsSync()) {
    final raw = file.readAsStringSync();
    final data = json.decode(raw);
    main = Data(token: data['token']);
  }
  else {
    main = Data();
    await saveData();
  }

  return Future.value();
}

Future<void> saveData() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/data.json');
  file.writeAsStringSync(json.encode({
    'token': main.token
  }));

  return Future.value();
}
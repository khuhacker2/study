import 'dart:convert';

import 'package:http/http.dart' as http;

const String SERVER_URL = 'http://192.168.0.2:8080';

Future<http.Response> get(String resource, {Map<String, String> headers}) {
  return http.get(SERVER_URL + resource, headers: headers);
}

Future<http.Response> post(String resource, {Map<String, String> headers, dynamic body}) {
  if(headers == null)
    headers = {};
  if(!headers.containsKey('Content-Type'))
    headers['Content-Type'] = 'application/json';
  return http.post(SERVER_URL + resource, headers: headers, body: json.encode(body));
}
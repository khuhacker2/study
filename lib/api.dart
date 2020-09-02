import 'dart:convert';

import 'package:http/http.dart' as http;

const String SERVER_URL = 'http://192.168.75.231:8080';

Future<http.Response> get(String resource, {Map<String, String> headers}) {
  return http.get(SERVER_URL + resource, headers: headers);
}

Future<http.Response> post(String resource, {Map<String, String> headers, dynamic body, bool rawBody=false}) {
  if(headers == null)
    headers = {};
  if(!headers.containsKey('Content-Type'))
    headers['Content-Type'] = 'application/json';
  return http.post(SERVER_URL + resource, headers: headers, body: rawBody ? body : json.encode(body));
}

Future<http.Response> put(String resource, {Map<String, String> headers, dynamic body, bool rawBody=false}) {
  if(headers == null)
    headers = {};
  if(!headers.containsKey('Content-Type'))
    headers['Content-Type'] = 'application/json';
  return http.put(SERVER_URL + resource, headers: headers, body: rawBody ? body : json.encode(body));
}
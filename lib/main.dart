import 'dart:convert';

import 'package:http/http.dart' as http;
void main() async {
  var url = Uri.http('127.0.0.1:8000', '/newacc');
  var body = jsonEncode(
    {'name': 'doodle', 'color': 'blue'}
  );
  var headers = <String, String>{
    'Content-Type': 'application/json',
    'Content-Length': body.length.toString(),
  };
  var response = await http.post(
    url,
    body: body,
    headers: headers,
  );
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
}

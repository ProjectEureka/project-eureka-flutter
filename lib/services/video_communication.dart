import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VideoCallService {

  Future<String> getTokenCall(String userId) async {
    await DotEnv.load();

    print("Token requested");
    final response = await http.get('http://10.0.2.2:8080/v1/call/' + userId);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      print("Token received");

      return body['token'];
    } else {
      throw Exception('Failed to load token');
    }
  }

  Future<String> getTokenAnswer(String userId) async {

    await DotEnv.load();

    print("Token requested");
    final response = await http.get('http://10.0.2.2:8080/v1/answer/' + userId);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      print("Token received");

      return body['token'];
    } else {
      throw Exception('Failed to load token');
    }
  }
}

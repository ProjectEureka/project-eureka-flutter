import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VideoCallService {

  Future<String> getTokenCall(String userId) async {
    await DotEnv.load();

    print("Call -token requested");
    final response = await http.get('http://192.168.1.2:8080/v1/call/' + userId);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      print("Call - token received");

      return body['token'];
    } else {
      throw Exception('Failed to load token');
    }
  }

  Future<String> getTokenAnswer(String userId) async {

    await DotEnv.load();

    print("Call answer - token requested");
    final response = await http.get('http://192.168.1.2:8080/v1/answer/' + userId);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      if (body['token'] != "error") {
        print("Call answer - token received");
        print(body);
      }
      else {
        print("Call is not active");
      }

      return body['token'];
    } else {
      throw Exception('Failed to load token');
    }
  }

  Future<void> hungUpCaller(String userId) async {

    await DotEnv.load();

    final response = await http.delete('http://10.0.2.2:8080/v1/hungup/' + userId);
    if (response.statusCode == 200) {
      print("Caller hung up");
    } else {
      throw Exception('Failed to end the call');
    }
  }
}

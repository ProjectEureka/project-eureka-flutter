import 'package:project_eureka_flutter/models/answer_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewAnswerService {
  Future<http.Response> postNewAnswer(AnswerModel answer) async {
    await DotEnv.load();

    final response = await http.post(
      Uri.https(
        DotEnv.env['HOST'],
        '/v1/answers',
      ),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        answer,
      ),
    );

    if (response.statusCode == 201) {
      print('Answer was added to database.');
      return response;
    } else {
      throw Exception('Failed to add answer to database.');
    }
  }
}

import 'package:project_eureka_flutter/models/question_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewQuestionService {
  Future<http.Response> postNewQuestion(QuestionModel question) async {
    await DotEnv.load();

    final response = await http.post(
      Uri.http(
        DotEnv.env['HOST'] + ':' + DotEnv.env['PORT'],
        '/v1/questions/',
      ),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        question,
      ),
    );

    if (response.statusCode == 201) {
      print('Question was added to database.');
      return response;
    } else {
      throw Exception('Failed to add question to database.');
    }
  }
}

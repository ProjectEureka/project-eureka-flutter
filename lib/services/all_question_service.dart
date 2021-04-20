import 'package:project_eureka_flutter/models/question_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AllQuestionService {
  // GET
  Future<List<QuestionModel>> getQuestions() async {
    await DotEnv.load();

    final response = await http.get(Uri.http(
        DotEnv.env['HOST'] + ':' + DotEnv.env['PORT'], '/v1/questions'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      // Backend service returns a list of json instances, while we need a list of question objects.
      // JSON parser will go through each json instance, transform it to a question object,
      //   and append to the list that will be used in eureka_list_view
      // Loop is reversed, as we want to sort the questions by date and show the most recent questions on top
      //   (new questions are appending to the bottom of the database)

      final body = json.decode(response.body);
      print("All questions were loaded");

      List<QuestionModel> questions = new List();
      for (var i = body.length - 1; i >= 0; i--) {
        if (body[i]['visible']) {
          questions.add(QuestionModel.fromJson(body[i]));
        }
      }
      // Sort questions by status (Active or closed)
      questions
          .sort((b, a) => b.closed.toString().compareTo(a.closed.toString()));
      return questions;
    } else {
      throw Exception('Failed to load questions');
    }
  }
}

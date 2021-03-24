import 'package:project_eureka_flutter/models/question_model.dart';
import 'package:project_eureka_flutter/models/answer_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileService {

  Future<List<QuestionModel>> getProfileQuestions() async {
    // profile id will be changed to the current user id associated with firebase id
    await DotEnv.load();

    final response = await http.get(Uri.http(DotEnv.env['HOST'] + ':' + DotEnv.env['PORT'], '/v1/profile/605800d2218f8a46677f3d41'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      // Backend service returns a list of json instances, while we need a list of question objects.
      // JSON parser will go through each json instance, transform it to a question object,
      //   and append to the list that will be used in eureka_list_view
      // Loop is reversed, as we want to sort the questions by date and show the most recent questions on top
      //   (new questions are appending to the bottom of the database)

      final body = json.decode(response.body);
      print("Profile questions were loaded");

      List<QuestionModel> questions = new List();
      for (var i = body['questions'].length - 1; i >= 0; i--) {
        questions.add(QuestionModel.fromJson(body['questions'][i]));
      }

      return questions;
    } else {
      throw Exception('Failed to load questions');
    }
  }

  Future<List<AnswerModel>> getProfileAnswers() async {

    await DotEnv.load();

    final response = await http.get(Uri.http(DotEnv.env['HOST'] + ':' + DotEnv.env['PORT'], '/v1/profile/605800d2218f8a46677f3d41'));

    if (response.statusCode == 200) {

      final body = json.decode(response.body);
      print("Profile answers were loaded");

      List<AnswerModel> answers = new List();
      for (var i = body['answers'].length - 1; i >= 0; i--) {
        answers.add(AnswerModel.fromJson(body['answers'][i]));
      }
      return answers;

    } else {
      throw Exception('Failed to load answers');
    }
  }
}

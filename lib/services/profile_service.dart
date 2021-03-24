import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_eureka_flutter/models/question_model.dart';
import 'package:project_eureka_flutter/models/answer_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_eureka_flutter/models/user_model.dart';

import 'email_auth.dart';

class ProfileService {

  Future<List<dynamic>> getProfileInformation(String userID) async {

    // profile id will be changed to the current user id associated with firebase id
    await DotEnv.load();

    final response = await http.get(Uri.http(DotEnv.env['HOST'] + ':' + DotEnv.env['PORT'], '/v1/profile/' + userID));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      // Backend service returns a list of json instances, while we need a list of question objects.
      // JSON parser will go through each json instance, transform it to a question object,
      //   and append to the list that will be used in eureka_list_view
      // Loop is reversed, as we want to sort the questions by date and show the most recent questions on top
      //   (new questions are appending to the bottom of the database)

      final body = json.decode(response.body);

      body['user'].length != 0 ? print("Profile user info was loaded") : print("Profile user info wasn't loaded");
      body['questions'].length != 0 ? print("Profile questions were loaded") : print("Profile questions were load. No questions found with this user ID");
      body['answers'].length != 0 ? print("Profile answers were loaded") : print("Profile answers were load. No answers found with this user ID");

      List<QuestionModel> questions = new List();
      List<AnswerModel> answers = new List();
      UserModel user = UserModel.fromJson(body['user']);

      // profileInfo will be a dynamic List containing user's info, questions list, answers list
      List<dynamic> profileInfo = new List();

      for (var i = body['questions'].length - 1; i >= 0; i--) {
        questions.add(QuestionModel.fromJson(body['questions'][i]));
      }
      for (var i = body['answers'].length - 1; i >= 0; i--) {
        answers.add(AnswerModel.fromJson(body['answers'][i]));
      }

      profileInfo.add(questions); // index 0
      profileInfo.add(answers); // index 1
      profileInfo.add(user); // index 2

      return profileInfo;
    } else {
      throw Exception('Failed to load profile data');
    }
  }
}

import 'package:project_eureka_flutter/models/question_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileService {

  // GET
  Future<List<QuestionModel>> fetchProfileQuestion() async {
    // profile id will be later changed to the current user id associated with firebase id
    final response = await http.get(Uri.http('IP ADDRESS', '/v1/profile/PROFILE ID'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final body = json.decode(response.body);
      print("Profile questions were loaded");

      // Backend service returns a list of json instances, while we need a list of question objects.
      // JSON parser will go through each json instance, transform it to a question object,
      //   and append to the list that will be used in eureka_list_view
      // Loop is reversed, as we want to sort the questions by date and show the most recent questions on top
      //   (new questions are appending to the bottom of the database)
      List<QuestionModel> questions = new List();
      for (var i = body['questions'].length - 1; i >= 0; i--) {
        questions.add(QuestionModel.fromJson(body['questions'][i]));
      }

      return questions;
    } else {
      throw Exception('Failed to load answers');
    }
  }
}

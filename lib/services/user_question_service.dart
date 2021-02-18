import 'package:project_eureka_flutter/models/question_model.dart';

class UserQuestionService {
  // Here Eureka will get data from the database.
  // At this point it contains just dummy lists of questions for test purposes
  Future<List> getQuestions() async {
    // List of another 2 dummy questions (different)
    List list3 = List.generate(2, (index) => "Message")
        .map((val) => QuestionModel(
              category: "Technology",
              date: DateTime.now(),
              status: 0,
              visible: 1,
              title: "iPhone not working",
              description: "iphone stopped working",
            ))
        .toList();
    return list3;
  }
}

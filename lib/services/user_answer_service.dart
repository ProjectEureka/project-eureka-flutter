import 'package:project_eureka_flutter/models/question_model.dart';

class UserAnswerService {
  // Here Eureka will get data from the database.
  // At this point it contains just dummy lists of questions for test purposes
  Future<List> getAnswers() async {
    List data = [];
    // List of another 2 dummy questions (different)
    List list2 = List.generate(2, (index) => "Message")
        .map((val) => QuestionModel(
              category: "Household",
              time: "2 hours ago",
              status: "",
              title: "Windows Issue",
              description: "Hello",
            ))
        .toList();

    // List of another 2 dummy questions (different)
    List list3 = List.generate(2, (index) => "Message")
        .map((val) => QuestionModel(
              category: "Technology",
              time: "2 weeks ago",
              status: "",
              title: "iPhone not working",
              description: "iphone stopped working",
            ))
        .toList();

    // Combined 6 dummy questions together
    data = new List.from(list2)..addAll(list3);
    return data;
  }
}

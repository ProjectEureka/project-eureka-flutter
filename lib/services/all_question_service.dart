import 'package:project_eureka_flutter/models/question_model.dart';

class AllQuestionService {
  // Here Eureka will get data from the database.
  // At this point it contains just dummy lists of questions for test purposes
  Future<List> getQuestions() async {
    List data = [];
    // List of 2 dummy questions
    List list1 = List.generate(2, (index) => "Message")
        .map((val) => QuestionModel(
              category: "Technology",
              time: "2 hours ago",
              status: "Active",
              title: "Linux installation issue - usb not found",
              description:
                  "Hello. I have a Smartbuy 16Gb USB 2.0 flash drive (with new memory controller) that is not recognized in any Linux system, but on Windows it recognized and worked fine. When I connect it to the PC on Linux system, nothing happens",
            ))
        .toList();

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
    List list2list3 = new List.from(list2)..addAll(list3);
    data = new List.from(list1)..addAll(list2list3);
    return data;
  }
}

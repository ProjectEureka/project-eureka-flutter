import 'package:project_eureka_flutter/models/question_model.dart';
import 'package:project_eureka_flutter/models/user_model.dart';
import 'package:project_eureka_flutter/models/user_answer_model.dart';

class MoreDetailModel {
  final UserModel user;
  final QuestionModel question;
  final List<UserAnswerModel> userAnswer;

  MoreDetailModel({
    this.user,
    this.question,
    this.userAnswer,
  });

  factory MoreDetailModel.fromJson(Map<dynamic, dynamic> json) {
    return MoreDetailModel(
      user: UserModel.fromJson(
          json['user']), // deserialize users into User object
      question: QuestionModel.fromJson(
          json['question']), // deserialize questions into object
      userAnswer: List<UserAnswerModel>.from(
        json['userAnswer'].map(
          (userAnswer) => UserAnswerModel.fromJson(userAnswer),
        ),
      ), // deserialize userAnswers into object
    );
  }
}

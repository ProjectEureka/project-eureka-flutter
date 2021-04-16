import 'package:project_eureka_flutter/models/answer_model.dart';
import 'package:project_eureka_flutter/models/user_model.dart';

class UserAnswerModel {
  final UserModel user;
  final AnswerModel answer;

  UserAnswerModel({
    this.user,
    this.answer,
  });

  factory UserAnswerModel.fromJson(List<dynamic> json) {
    return UserAnswerModel(
      user: UserModel.fromJson(json[0]), // index 0 contains users
      answer: AnswerModel.fromJson(json[1]), // index 1 contains answers
    );
  }
}

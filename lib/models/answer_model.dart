class AnswerModel {
  final String id;
  final List<dynamic> mediaUrls;
  final String answerDate;
  final String description;
  final String questionId;
  final bool bestAnswer;
  final String userId;

  AnswerModel({
    this.id,
    this.mediaUrls,
    this.answerDate,
    this.description,
    this.questionId,
    this.bestAnswer,
    this.userId,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['id'],
      mediaUrls: json['mediaUrls'],
      answerDate: json['answerDate'],
      description: json['description'],
      questionId: json['questionId'],
      bestAnswer: json['bestAnswer'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'mediaUrls': mediaUrls,
        'answerDate': answerDate,
        'description': description,
        'questionId': questionId,
        'bestAnswer': bestAnswer,
        'userId': userId,
      };
}

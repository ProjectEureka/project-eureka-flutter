class QuestionModel {
  final String id;
  final String title;
  final String questionDate;
  final String description;
  final String category;
  // for Lists (both for list of string and list of integers), use List<dynamic>, e
  final List<dynamic> mediaUrls;
  final bool status;
  final bool visible;
  final String userId;

  QuestionModel(
      {this.id,
      this.title,
      this.questionDate,
      this.description,
      this.category,
      this.mediaUrls,
      this.status,
      this.visible,
      this.userId});

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      title: json['title'],
      questionDate: json['questionDate'],
      description: json['description'],
      category: json['category'],
      mediaUrls: json['mediaUrls'],
      status: json['status'],
      visible: json['visible'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'questionDate': questionDate,
        'description': description,
        'category': category,
        'mediaUrls': mediaUrls,
        'status': status,
        'visible': visible,
        'userId': userId,
      };
}

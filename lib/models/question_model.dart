class QuestionModel {
  final String id;
  final String title;
  final String questionDate;
  final String description;
  final String category;

  // for Lists (both for list of string and list of integers), use List<dynamic>, e
  final List<dynamic> mediaUrls;
  final bool closed;
  final bool visible;
  final String userId;

  QuestionModel({
    this.id,
    this.title,
    this.questionDate,
    this.description,
    this.category,
    this.mediaUrls,
    this.closed,
    this.visible,
    this.userId,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      title: json['title'],
      questionDate: json['questionDate'],
      description: json['description'],
      category: json['category'],
      mediaUrls: json['mediaUrls'],
      closed: json['closed'],
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
        'closed': closed,
        'visible': visible,
        'userId': userId,
      };
}

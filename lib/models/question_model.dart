class QuestionModel {
  final String id;
  final String title;
  final DateTime date;
  final String description;
  final List<String> mediaUrls;
  final String category;
  final int status;
  final int visible;
  final String uuid;

  QuestionModel({
    this.id,
    this.title,
    this.date,
    this.description,
    this.mediaUrls,
    this.category,
    this.status,
    this.visible,
    this.uuid,
  });
}

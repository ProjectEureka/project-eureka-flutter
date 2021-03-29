class RatingModel {
  final String id;
  final double rating;

  RatingModel({this.id, this.rating});

  Map<String, dynamic> toJson() => {
        'id': id,
        'rating': rating,
      };

  factory RatingModel.fromJSON(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'],
      rating: json['rating'],
    );
  }
}

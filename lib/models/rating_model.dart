class RatingModel {
  final String id;
  final double rating;

  RatingModel({this.id, this.rating});

  Map<String, dynamic> toJson() => {
        'id': id,
        'rating': rating,
      };
}

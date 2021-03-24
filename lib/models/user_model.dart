class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String firebaseUuid;
  final String email;
  final String city;
  final List<dynamic> category;
  final String pictureUrl;
  final int role;
  final List<dynamic> ratings;
  final double averageRating;

  UserModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.firebaseUuid,
      this.email,
      this.city,
      this.category,
      this.pictureUrl,
      this.role,
      this.ratings,
      this.averageRating});

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'firebaseUuid': firebaseUuid,
        'email': email,
        'city': city,
        'category': category,
        'pictureUrl': pictureUrl,
        'role': role,
        'ratings': ratings,
        'averageRating': averageRating,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      firebaseUuid: json['firebaseUuid'],
      email: json['email'],
      city: json['city'],
      category: json['category'],
      pictureUrl: json['pictureUrl'],
      role: json['role'],
      ratings: json['ratings'],
      averageRating: json['averageRating'],
    );
  }
}

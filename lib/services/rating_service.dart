import 'package:project_eureka_flutter/models/rating_model.dart';
import 'package:project_eureka_flutter/models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RatingService {
  Future<void> updateRating(RatingModel rating) async {
    await DotEnv.load();

    final response = await http.put(
      Uri.http(
        DotEnv.env['HOST'] + ':' + DotEnv.env['PORT'],
        '/v1/users/${rating.id}/rating',
      ),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        rating.toJson(),
      ),
    );

    if (response.statusCode == 200) {
      print('User was rated successfully.');
    } else {
      throw Exception('Failed to load user ratings.');
    }
  }
}

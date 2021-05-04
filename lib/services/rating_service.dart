import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
import 'package:project_eureka_flutter/models/rating_model.dart';

class RatingService {
  Future<http.Response> updateRating(RatingModel rating) async {
    await DotEnv.load();
    final response = await http.put(
      Uri.https(
        DotEnv.env['HOST'],
        '/v1/users/${rating.id}/rating',
      ),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        rating.toJson(),
      ),
    );
    print("User was rated successfully - " + response.statusCode.toString());
    return response;
  }
}

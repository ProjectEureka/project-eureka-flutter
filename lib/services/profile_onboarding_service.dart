import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
import 'package:project_eureka_flutter/models/user_model.dart';

class ProfileOnboardingService {
  Future<http.Response> addUser(UserModel user) async {
    await DotEnv.load();

    return http.post(
      Uri.https(
        DotEnv.env['HOST'],
        '/v1/users',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        user.toJson(),
      ),
    );
  }

  Future<http.Response> updateUser(String userId, UserModel user) async {
    await DotEnv.load();

    return http.put(
      Uri.https(
        DotEnv.env['HOST'],
        '/v1/users/$userId',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        user.toJson(),
      ),
    );
  }
}

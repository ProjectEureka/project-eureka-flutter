import 'package:project_eureka_flutter/models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileOnboardingService {
  Future<http.Response> addUser(UserModel user) {
    return http.post(
      Uri.http(
        DotEnv.env['HOST'] + ':' + DotEnv.env['PORT'],
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

  Future<http.Response> updateUser(UserModel user) {
    return http.put(
      Uri.http(
        DotEnv.env['HOST'] + ':' + DotEnv.env['PORT'],
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
}

import 'package:project_eureka_flutter/models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AllUsersService {
  // GET

  Future<List<UserModel>> getUsers() async {
    await DotEnv.load();
    final response = await http.get(
        Uri.http(DotEnv.env['HOST'] + ':' + DotEnv.env['PORT'], '/v1/users'));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      print("Users were loaded");

      List<UserModel> users = new List();
      for (var i = body.length - 1; i >= 0; i--) {
        users.add(UserModel.fromJson(body[i]));
      }
      // Sort questions by status (Active or closed)
      for (var user in users) {
        print("User:");
        print(user.id +
            " " +
            user.firstName +
            " " +
            user.lastName +
            " " +
            user.id +
            " " +
            user.firebaseUuid +
            " " +
            user.city +
            " " +
            user.pictureUrl +
            " ");
        print(user.role);
      }

      return users;
    } else {
      throw Exception('Failed to load questions');
    }
  }
}

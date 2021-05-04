import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
import 'package:project_eureka_flutter/models/user_model.dart';

class UserService {
  // GET
  Future<UserModel> getUserById(String uid) async {
    await DotEnv.load();

    final response =
        await http.get(Uri.https(DotEnv.env['HOST'], '/v1/users/' + uid));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      UserModel user = UserModel.fromJson(body);
      return user;
    } else {
      throw Exception('Failed to load user');
    }
  }
}

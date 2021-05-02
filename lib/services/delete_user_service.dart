import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DeleteUserService {
  Future<http.Response> deleteUser(String id) async {
    await DotEnv.load();
    return await http.put(
      Uri.https(DotEnv.env['HOST'], '/v1/user/delete/$id'),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(null),
    );
  }
}

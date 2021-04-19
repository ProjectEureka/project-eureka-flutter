import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DeleteUserService {
  Future<http.Response> deleteUser(String id) async {
    await DotEnv.load();
    return await http.put(
      Uri.http(
        //DotEnv.env['HOST'] + ':' + DotEnv.env['PORT'], //When your backend is hosted uncomment this line
        '10.0.2.2:8080', // when backend is hosted comment this line out
        '/v1/user/delete/$id',
      ),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(null),
    );
  }
}

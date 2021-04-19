import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CloseQuestionService {
  Future<http.Response> closeQuestion(String questionId, String answerId) async {
    await DotEnv.load();

    return await http.put(Uri.http(DotEnv.env['HOST_LOCAL'] + ':' + DotEnv.env['PORT_LOCAL'], '/v1/question/$questionId/close'),
      body: answerId,
    );
  }
}

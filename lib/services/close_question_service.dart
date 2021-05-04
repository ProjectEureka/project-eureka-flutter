import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;

class CloseQuestionService {
  Future<http.Response> closeQuestion(
      String questionId, String answerId) async {
    await DotEnv.load();

    return await http.put(
      Uri.https(DotEnv.env['HOST'], '/v1/question/$questionId/close'),
      body: answerId,
    );
  }

  Future<http.Response> archiveQuestion(String questionId) async {
    await DotEnv.load();

    return await http.put(
      Uri.https(DotEnv.env['HOST'], '/v1/questions/$questionId/archive'),
    );
  }
}

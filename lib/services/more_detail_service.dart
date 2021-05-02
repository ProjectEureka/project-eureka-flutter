import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:project_eureka_flutter/models/more_details_model.dart';

class MoreDetailService {
  Future<MoreDetailModel> getMoreDetail(String questionId) async {
    await DotEnv.load();

    final http.Response response = await http.get(
      Uri.https(DotEnv.env['HOST'], 'v1/questions/$questionId/details'),
    );

    MoreDetailModel moreDetailModel =
        MoreDetailModel.fromJson(json.decode(response.body));

    moreDetailModel.userAnswer
        .sort((a, b) => b.answer.bestAnswer.toString().compareTo(
              a.answer.bestAnswer.toString(),
            ));

    return moreDetailModel;
  }
}

import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/screens/rating_page.dart';
import 'package:project_eureka_flutter/services/close_question_service.dart';

import 'home_page.dart';

class ChooseBestAnswer extends StatefulWidget {

  final String questionId;
  // In development: it will need to pass the list of answers
  final String answerId;

  const ChooseBestAnswer({this.questionId, this.answerId});

  @override
  _ChooseBestAnswerState createState() => _ChooseBestAnswerState();
}

class _ChooseBestAnswerState extends State<ChooseBestAnswer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EurekaAppBar(
        title: 'Choose the Best Answer',
        appBar: AppBar(),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RatingPage(questionId: widget.questionId, answerId: widget.answerId
                    ,)), //archive question
            );
          },
          child: Text('Best Answer'),
        ),
      ),
    );
  }
}

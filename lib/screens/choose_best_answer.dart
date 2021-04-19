import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/services/close_question_service.dart';

class ChooseBestAnswer extends StatefulWidget {

  final String questionId;
  // In development: it will need to pass the list of answers
  final String answerId;

  const ChooseBestAnswer({Key key, this.questionId, this.answerId}) : super(key: key);

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
            final response = await CloseQuestionService().closeQuestion(widget.questionId, widget.answerId);
            print("Status " + response.statusCode.toString() + ". Question closed successfully - " + widget.questionId.toString());
          },
          child: Text('Best Answer'),
        ),
      ),
    );
  }
}

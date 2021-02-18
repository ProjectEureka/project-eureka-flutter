import 'package:flutter/material.dart';

class NewQuestionForm extends StatefulWidget {
  final String categoryName;

  NewQuestionForm(
    this.categoryName,
  );

  @override
  _NewQuestionFormState createState() => _NewQuestionFormState();
}

class _NewQuestionFormState extends State<NewQuestionForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Question"),
      ),
      body: Center(
        child: Text(widget.categoryName),
      ),
    );
  }
}

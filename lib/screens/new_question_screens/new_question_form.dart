import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/eureka_rounded_button.dart';
import 'package:project_eureka_flutter/components/eureka_text_form_field.dart';
import 'package:project_eureka_flutter/components/eureka_toggle_switch.dart';
import 'package:project_eureka_flutter/models/question_model.dart';
import 'package:project_eureka_flutter/screens/new_question_screens/new_question_confirmation.dart';

class NewQuestionForm extends StatefulWidget {
  final String categoryName;

  /// constructor to allow objects to be passed from another class
  NewQuestionForm(
    this.categoryName,
  );

  @override
  _NewQuestionFormState createState() => _NewQuestionFormState();
}

class _NewQuestionFormState extends State<NewQuestionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static final RegExp _nameRegExp = RegExp(
      "[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.'-]");

  int _role = 0;
  String _questionTitle;
  String _questionBody;

  QuestionModel _question;

  Column _textForm() {
    return Column(
      children: <Widget>[
        EurekaTextFormField(
          labelText: 'Question Title',
          errValidatorMsg: 'Question title is required.',
          regExp: _nameRegExp,
          onSaved: (value) => _questionTitle = value.trim(),
        ),
        EurekaTextFormField(
          labelText: 'Please explain in detail your question...',
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
          maxLines: 10,
          errValidatorMsg: 'Question body is required.',
          regExp: _nameRegExp,
          onSaved: (value) => _questionBody = value.trim(),
        ),
      ],
    );
  }

  Column _pictureForm() {
    return Column(
      children: <Widget>[
        Center(
          child: Container(
            child: Text("Create the picture form here..."),
          ),
        )
      ],
    );
  }

  Column _videoForm() {
    return Column(
      children: <Widget>[
        Center(
          child: Container(
            child: Text("Create the video form here..."),
          ),
        )
      ],
    );
  }

  SingleChildScrollView _scrollingForm() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          EurekaToggleSwitch(
              labels: ['Text', 'Photo', 'Video'],
              initialLabelIndex: _role,
              setState: (index) {
                setState(() {
                  _role = index;
                });
              }),
          Visibility(
            visible: _role == 0 ? true : false,
            child: _textForm(),
          ),
          Visibility(
            visible: _role == 1 ? true : false,
            child: _pictureForm(),
          ),
          Visibility(
            visible: _role == 2 ? true : false,
            child: _videoForm(),
          )
        ],
      ),
    );
  }

  void _validateAndSubmit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    DateTime _date = DateTime.now();

    setState(() {
      _question = new QuestionModel(
        title: _questionTitle,
        date: _date,
        description: _questionBody,
        category: widget.categoryName,
        status: 0,
        visible: 1,
      );

      print(
          "${_question.title}, ${_question.date}, ${_question.description}, ${_question.category}, ${_question.status}, ${_question.visible}");
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewQuestionConfirmation(
          questionModel: _question,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Question"),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: _scrollingForm(),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: EurekaRoundedButton(
          onPressed: () => _validateAndSubmit(),
          buttonText: 'Submit',
        ),
      ),
    );
  }
}

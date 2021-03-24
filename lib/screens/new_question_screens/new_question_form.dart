import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/components/eureka_rounded_button.dart';
import 'package:project_eureka_flutter/components/eureka_text_form_field.dart';
import 'package:project_eureka_flutter/components/eureka_toggle_switch.dart';
import 'package:project_eureka_flutter/components/eureka_camera_form.dart';
import 'package:project_eureka_flutter/models/question_model.dart';
import 'package:project_eureka_flutter/screens/new_question_screens/new_question_confirmation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';
import 'package:uuid/uuid.dart';

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

  /// this regex will most characters with a minimum of 6
  static final RegExp _regExp = RegExp(
      "[0-9a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.'-]{6,}");

  int _role = 0;
  String _questionTitle;
  String _questionBody;

  QuestionModel _question;

  List<String> _mediaPaths = [];
  ImagePicker _picker = ImagePicker();
  FirebaseStorage storage = FirebaseStorage.instance;
  bool _isUploading = false;

  Column _textForm() {
    return Column(
      children: <Widget>[
        EurekaTextFormField(
          labelText: 'Question Title',
          errValidatorMsg: 'Question title is required.',
          regExp: _regExp,
          onSaved: (value) => _questionTitle = value.trim(),
          initialValue: _questionTitle == null ? null : _questionTitle,
        ),
        EurekaTextFormField(
          labelText: 'Please explain in detail your question...',
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
          maxLines: 10,
          errValidatorMsg: 'Question body is required.',
          regExp: _regExp,
          onSaved: (value) => _questionBody = value.trim(),
          initialValue: _questionBody == null ? null : _questionBody,
        ),
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

  Widget _scrollingForm() {
    return _isUploading
        ? Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                Text('Uploading files...'),
              ],
            ),
          )
        : SingleChildScrollView(
            child: Column(
              children: <Widget>[
                EurekaToggleSwitch(
                    labels: ['Text', 'Photo', 'Video'],
                    initialLabelIndex: _role,
                    setState: (index) {
                      setState(() {
                        _formKey.currentState.save();
                        _role = index;
                      });
                    }),
                Visibility(
                  visible: _role == 0 ? true : false,
                  child: _textForm(),
                ),
                Visibility(
                  visible: _role == 1 ? true : false,
                  child: EurekaCameraForm(
                    mediaPaths: _mediaPaths,
                    picker: _picker,
                  ),
                ),
                Visibility(
                  visible: _role == 2 ? true : false,
                  child: _videoForm(),
                )
              ],
            ),
          );
  }

  Future<List<String>> uploadFiles(String _questionId) async {
    List<String> _mediaUrls = [];

    setState(() {
      _isUploading = true;
    });

    /// iterates through _mediaPath list and upload one by one.
    for (String path in _mediaPaths) {
      File file = File(path);

      /// These next two varibles format the file name, best fit for Firebase.
      String fileName = path
          .substring(path.lastIndexOf("/"), path.lastIndexOf("."))
          .replaceAll("/", "");
      String uploadName =
          'images/userId_${EmailAuth().getCurrentUser().uid}/questionId_$_questionId/$fileName.jpg';

      try {
        /// uploads the file
        TaskSnapshot snapshot = await storage.ref(uploadName).putFile(file);

        /// get the download URL
        String downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          _mediaUrls.add(downloadUrl);
        });
      } catch (e) {
        print(e);
      }
    }

    setState(() {
      _isUploading = false;
    });

    return _mediaUrls;
  }

  Future<void> _validateForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    DateTime _date = DateTime.now();
    final String _questionId = Uuid().v1();

    List<String> downloadUrls = await uploadFiles(_questionId);

    /// Create new Object to be sent to backend.
    setState(() {
      _question = new QuestionModel(
        id: _questionId,
        title: _questionTitle,
        questionDate:
            _date.toIso8601String(), // format date to add `T` character
        description: _questionBody,
        mediaUrls: downloadUrls,
        category: widget.categoryName,
        status: true,
        visible: true,
      );
    });

    /// temp print object instead of send to back-end.
    /// when connecting backend, replace this print
    print(
        "${_question.id}, ${_question.title}, ${_question.questionDate}, ${_question.description}, ${_question.mediaUrls}, ${_question.category}, ${_question.status}, ${_question.visible}");

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => NewQuestionConfirmation(
          questionModel: _question,
        ),
      ),
      (Route<void> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EurekaAppBar(
        title: 'New Question',
        appBar: AppBar(),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: _scrollingForm(),
        ),
      ),
      bottomNavigationBar: _role == 0
          ? BottomAppBar(
              color: Colors.transparent,
              elevation: 0,
              child: EurekaRoundedButton(
                onPressed: () => _validateForm(),
                buttonText: 'Submit',
              ),
            )
          : null,
    );
  }
}

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/components/eureka_rounded_button.dart';
import 'package:project_eureka_flutter/components/eureka_text_form_field.dart';
import 'package:project_eureka_flutter/components/eureka_toggle_switch.dart';
import 'package:project_eureka_flutter/components/eureka_camera_form.dart';
import 'package:project_eureka_flutter/models/answer_model.dart';
import 'package:project_eureka_flutter/models/question_model.dart';
import 'package:project_eureka_flutter/screens/new_form_screens/new_form_confirmation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:project_eureka_flutter/services/new_question_service.dart';

class NewForm extends StatefulWidget {
  final String categoryName;
  final bool isAnswer;
  final QuestionModel questionModel;

  /// constructor to allow objects to be passed from another class
  NewForm({
    this.categoryName = '',
    @required this.isAnswer,
    this.questionModel,
  });

  @override
  _NewFormState createState() => _NewFormState();
}

class _NewFormState extends State<NewForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// this regex will most characters with a minimum of 6
  static final RegExp _regExp = RegExp(
      "[0-9a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.'-]{6,}");

  int _formType = 0;
  String _title;
  String _body;

  List<String> _mediaPaths = [];
  ImagePicker _imagePicker = ImagePicker();
  FirebaseStorage storage = FirebaseStorage.instance;
  bool _isUploading = false;

  Column _textForm() {
    return Column(
      children: <Widget>[
        widget.isAnswer // title form won't show for answer form
            ? Container()
            : EurekaTextFormField(
                labelText: 'Question Title',
                errValidatorMsg: 'Question title is required.',
                regExp: _regExp,
                onSaved: (value) => _title = value.trim(),
                initialValue: _title == null ? null : _title,
              ),
        EurekaTextFormField(
          labelText: widget.isAnswer
              ? 'Please provide an answer to the question...'
              : 'Please explain in detail your question...',
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
          maxLines:
              widget.isAnswer ? 15 : 10, // make body form bigger when answer
          errValidatorMsg: widget.isAnswer
              ? 'Answer body is required.'
              : 'Question body is required.',
          regExp: _regExp,
          onSaved: (value) => _body = value.trim(),
          initialValue: _body == null ? null : _body,
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
                    initialLabelIndex: _formType,
                    setState: (index) {
                      setState(() {
                        _formKey.currentState.save();
                        _formType = index;
                      });
                    }),
                Visibility(
                  visible: _formType == 0 ? true : false,
                  child: _textForm(),
                ),
                Visibility(
                  visible: _formType == 1 ? true : false,
                  child: EurekaCameraForm(
                    mediaPaths: _mediaPaths,
                    picker: _imagePicker,
                  ),
                ),
                Visibility(
                  visible: _formType == 2 ? true : false,
                  child: _videoForm(),
                )
              ],
            ),
          );
  }

  Future<List<String>> uploadFiles(String _id) async {
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
      String uploadName = widget.isAnswer
          ? 'images/answers/userId_${EmailAuth().getCurrentUser().uid}/answerId_$_id/$fileName.jpg'
          : 'images/questions/userId_${EmailAuth().getCurrentUser().uid}/questionId_$_id/$fileName.jpg';

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

  /// Creates the proper model, depending on wether if the form is for Questiion or Answer
  dynamic _createModel(
    String _id,
    DateTime _date,
    List<String> downloadUrls,
  ) {
    QuestionModel _question;
    AnswerModel _answer;

    if (widget.isAnswer) {
      /// builds answers model
      setState(() {
        _answer = new AnswerModel(
          id: _id,
          mediaUrls: downloadUrls,
          answerDate: _date.toIso8601String(),
          description: _body,
          questionId:
              "widget.questionModel.id", // remove quotes when the More Question Details service is complete
          //bestAnswer: false,
          userId: EmailAuth().getCurrentUser().uid,
        );
      });

      return _answer;
    } else {
      /// builds question model
      /// Create new Object to be sent to backend.
      setState(() {
        _question = new QuestionModel(
          id: _id,
          title: _title,
          questionDate:
              _date.toIso8601String(), // format date to add `T` character
          description: _body,
          mediaUrls: downloadUrls,
          category: widget.categoryName,
          closed: true,
          visible: true,
          userId: EmailAuth().getCurrentUser().uid,
        );
      });

      return _question;
    }
  }

  Future<void> _validateForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    DateTime _date = DateTime.now();
    final String _id = Uuid().v1();

    List<String> downloadUrls = await uploadFiles(_id);

    dynamic _model = _createModel(_id, _date, downloadUrls);

    try {
      widget.isAnswer
          ? null //Add POST answer here
          : await NewQuestionService()
              .postNewQuestion(_model); // POST question to database

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => widget.isAnswer
              ? NewFormConfirmation(
                  answerModel: _model,
                  isAnswer: true,
                )
              : NewFormConfirmation(
                  questionModel: _model,
                  isAnswer: false,
                ),
        ),
        (Route<void> route) => false,
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EurekaAppBar(
        title: widget.isAnswer ? 'Answer' : 'Question',
        appBar: AppBar(),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: _scrollingForm(),
        ),
      ),
      bottomNavigationBar: _formType == 0
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

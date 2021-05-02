import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/components/eureka_rounded_button.dart';
import 'package:project_eureka_flutter/components/more_details_view.dart';
import 'package:project_eureka_flutter/models/more_details_model.dart';
import 'package:project_eureka_flutter/models/question_model.dart';
import 'package:project_eureka_flutter/models/user_answer_model.dart';
import 'package:project_eureka_flutter/models/user_model.dart';
import 'package:project_eureka_flutter/screens/new_form_screens/new_form.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';
import 'package:project_eureka_flutter/services/more_detail_service.dart';
import 'package:project_eureka_flutter/screens/chat_screens/chat_screen.dart';
import 'package:project_eureka_flutter/screens/choose_best_answer.dart';

final _firestore = FirebaseFirestore.instance;

class MoreDetails extends StatefulWidget {
  final String questionId;

  MoreDetails({
    this.questionId,
  });

  @override
  _MoreDetailsState createState() => _MoreDetailsState();
}

class _MoreDetailsState extends State<MoreDetails> {
  MoreDetailModel _moreDetailModel = MoreDetailModel(
    question: QuestionModel(),
    user: UserModel(),
    userAnswer: [UserAnswerModel()],
  );
  String currUserId;
  bool loading;

  @override
  void initState() {
    loading = true;
    initGetQuestionDetails();
    currUserId = EmailAuth().getCurrentUser().uid;
    super.initState();
  }

  void initGetQuestionDetails() async {
    await MoreDetailService().getMoreDetail(widget.questionId).then((payload) {
          setState(() {
            _moreDetailModel = payload;
            loading = false;
          });
        });
  }

  EurekaRoundedButton _messageModalButton() {
    return EurekaRoundedButton(
      onPressed: () {
        addChatToFirebase();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              fromId: _moreDetailModel.user.id,
              recipient: _moreDetailModel.user.firstName,
              questionId: _moreDetailModel.question.id,
            ),
          ),
        );
      },
      buttonText: 'Message ${_moreDetailModel.user.firstName}',
      isTwoButtons: true,
    );
  }

  EurekaRoundedButton _answerFormModalButton() {
    return EurekaRoundedButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewForm(
            isAnswer: true,
            questionId: widget.questionId,
          ),
        ), // standard form
      ),
      buttonText: 'Answer ',
      isTwoButtons: true,
    );
  }

//This is used to create the collection in which the the chat messages between the current user
// and the question user will be stored, denoted by the groupChatId
  void addChatToFirebase() {
    String groupChatId =
        '$currUserId-${_moreDetailModel.user.id}-${_moreDetailModel.question.id}';

    _firestore.collection('messages').doc(groupChatId).set({
      'chatIDUser': currUserId,
      'recipientId': _moreDetailModel.user.id,
      'questionTitle': _moreDetailModel.question.title,
      'questionId': _moreDetailModel.question.id,
      'timestamp': DateTime.now(),
    });
  }

  EurekaRoundedButton _answerQuestionButton() {
    return EurekaRoundedButton(
      onPressed: () {
        _moreDetailModel.user.id == currUserId
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewForm(
                    isAnswer: true,
                    questionId: widget.questionId,
                  ),
                ), // standard form
              )
            : showModalBottomSheet(
                context: context,
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _messageModalButton(),
                    _answerFormModalButton(),
                  ],
                ),
              );
      },
      buttonText: "Answer",
    );
  }

  EurekaRoundedButton _closeQuestionButton() {
    return EurekaRoundedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChooseBestAnswer(
              questionId: widget.questionId,
              answers: _moreDetailModel.userAnswer,
            ),
          ),
        );
      },
      buttonText: "Question Solved?",
    );
  }

  Visibility _noAnswersResponse() {
    return Visibility(
      visible: _moreDetailModel.userAnswer.length == 0,
      child: Column(
        children: [
          SizedBox(height: 20.0),
          Text(
            "There are no answers yet, add one below!",
            style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Column _answersListBuilder() {
    return Column(
      children: [
        for (UserAnswerModel userAnswer in _moreDetailModel.userAnswer)
          MoreDetailsView(
            moreDetailModel: _moreDetailModel,
            isAnswer: true,
            userAnswerModel: userAnswer,
            isCurrUser: _moreDetailModel.user.id == currUserId,
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EurekaAppBar(
        title: 'Question Details',
        appBar: AppBar(),
      ),
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 269.0,
          ),
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(!loading)
                MoreDetailsView(
                  moreDetailModel: _moreDetailModel,
                  isAnswer: false,
                  isCurrUser: _moreDetailModel.user.id == currUserId,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                  child: Divider(
                    color: Colors.black,
                    thickness: 2.0,
                    height: 0.0,
                  ),
                ),
                Text(
                  "${_moreDetailModel.userAnswer.length} Answers",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    color: Color(0xFF00ADB5),
                  ),
                ),
                _noAnswersResponse(),
                if(!loading)
                _answersListBuilder(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: _moreDetailModel.question == null // wait for questions to load
                ||
                (_moreDetailModel.userAnswer.length ==
                        0 // check if userAnswer contains anything
                    ? false
                    : _moreDetailModel.userAnswer[0].user ==
                        null) // waits for user of answer to load if answers exist
                ||
                (_moreDetailModel.userAnswer.length ==
                        0 // check if userAnswer contains anything
                    ? false
                    : _moreDetailModel.userAnswer[0].answer ==
                        null) // waits for answers to load if answers exist
            ? Container(
                child: Center(
                  child:
                      CircularProgressIndicator(), // if still waiting for above, show loading indicator
                ),
              )
            : ( //else show the approriate button
                (_moreDetailModel.userAnswer.length == 0
                        ? false
                        : _moreDetailModel.userAnswer[0].answer.bestAnswer ==
                            true)
                    ? null
                    : (_moreDetailModel.user.id !=
                            currUserId // if currUser is question poster
                        ? _answerQuestionButton() // false = answer question
                        : ((_moreDetailModel.question.closed != true) & (_moreDetailModel.userAnswer.length != 0))
                          ? _closeQuestionButton() : null )),
      ),
    );
  }
}

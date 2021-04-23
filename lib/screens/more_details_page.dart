import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/components/eureka_rounded_button.dart';
import 'package:project_eureka_flutter/models/more_details_model.dart';
import 'package:project_eureka_flutter/screens/choose_best_answer.dart';

import 'package:project_eureka_flutter/screens/home_screen.dart';
import 'package:project_eureka_flutter/screens/new_form_screens/new_form.dart';
import 'package:project_eureka_flutter/services/close_question_service.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';
import 'package:project_eureka_flutter/services/more_detail_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class MoreDetails extends StatefulWidget {
  final String questionId;

  MoreDetails({
    this.questionId,
  });

  @override
  _MoreDetailsState createState() => _MoreDetailsState();
}

class _MoreDetailsState extends State<MoreDetails> {
  MoreDetailModel _moreDetailModel;

  final String currUserId = EmailAuth().getCurrentUser().uid;

  Widget _getMediaLinks() {
    return Column(
      children: <Widget>[
        Row(children: <Widget>[
          Text(
            'Media: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ]),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          childAspectRatio: 4 / 2,
          children: <Widget>[
            for (var item in _moreDetailModel.question.mediaUrls)
              FlatButton(
                onPressed: () {},
                child: Text(
                  "Media ${1 + _moreDetailModel.question.mediaUrls.indexOf(item)}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
          ],
        )
      ],
    );
  }

  @override
  void initState() {
    initGetQuestionDetails();
    super.initState();
  }

  Future<void> initGetQuestionDetails() async {
    MoreDetailModel payload = await MoreDetailService().getMoreDetail(
      widget.questionId,
    );

    setState(() {
      _moreDetailModel = payload;
    });
  }

  Column _headerStack() {
    return Column(
      children: [
        Container(
          height: 0,
        ),
        _profileNameAndIcon(),
      ],
    );
  }

  Row _profileNameAndIcon() {
    final DateTime dateTime =
        DateTime.parse(_moreDetailModel.question.questionDate)
            .subtract(new Duration(minutes: 1));
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 55.0,
          backgroundColor: Colors.grey[300],
          child: CircleAvatar(
            radius: 40.0,
            backgroundImage: _moreDetailModel.user.pictureUrl == ''
                ? AssetImage('assets/images/profile_default_image.png')
                : NetworkImage(_moreDetailModel.user.pictureUrl),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 10),
            ),
            Row(children: [
              Text(
                '${_moreDetailModel.user.firstName} ${_moreDetailModel.user.lastName}',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ]),
            Divider(color: Colors.transparent, height: 10.0),
            Row(children: [
              Text(
                "Category: ",
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              Text(
                _moreDetailModel.question.category,
                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300),
                textAlign: TextAlign.left,
              ),
            ]),
            Row(children: [
              Text(
                "Asked: ",
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              Text(
                timeago.format(dateTime),
                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300),
                textAlign: TextAlign.left,
              ),
            ]),
          ],
        ),
      ],
    );
  }

  EurekaRoundedButton _answerQuestionButton() {
    return EurekaRoundedButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              EurekaRoundedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewForm(
                      isAnswer: true,
                      questionId: widget.questionId,
                    ),
                  ), // standard form
                ),
                buttonText: 'No Chat',
              ),
              EurekaRoundedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewForm(
                      isAnswer: true,
                    ),
                  ), // change this to the chat form
                ),
                buttonText: 'Chat',
              ),
            ],
          ),
        );
      },
      buttonText: "Answer",
    );
  }

  Row _questionArchiveButton() {
    // In development:
    // 1: must show Archive button if question is not archived
    // 2: must show Close button if question is not closed yet or not archived yet
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      FlatButton(
        color: Color(0xFF00ADB5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        onPressed: () async {
          final response =
              await CloseQuestionService().archiveQuestion(widget.questionId);
          print("Status " +
              response.statusCode.toString() +
              ". Question archived successfully - " +
              widget.questionId.toString());
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    content: Text(
                      'Question was archived',
                      textAlign: TextAlign.center,
                    ),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Home()), //archive question
                              ),
                          child: Text('Back to Home')),
                    ],
                  ));
        },
        child: Container(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Archive", style: TextStyle(color: Colors.white)),
        )),
      ),
      SizedBox(width: 50),
      FlatButton(
        color: Color(0xFF00ADB5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChooseBestAnswer(
                      questionId: _moreDetailModel.question.id,
                      // Demo of choosing best answer
                      // In development: pass the answers list that will have all answers ID's
                      answerId: "607ce610930fdd5f952c1ce1",
                    )), //archive question
          );
        },
        child: Container(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Close", style: TextStyle(color: Colors.white)),
        )),
      ),
    ]);
  }

  Container _questionFieldViewer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _moreDetailModel.question.title,
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(color: Colors.transparent, height: 15.0),
          Text(
            _moreDetailModel.question.description,
          ),
          Divider(color: Colors.transparent, height: 15.0),
          _getMediaLinks()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EurekaAppBar(
        title: 'Question Details',
        appBar: AppBar(),
      ),
      body: _moreDetailModel.question == null ||
              _moreDetailModel.user == null ||
              _moreDetailModel.userAnswer == null
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : ListView(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      _headerStack(),
                      _questionFieldViewer(),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          // For demo purposes this is true, however will be changed to != later
          child: _moreDetailModel.user.id != currUserId
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(110, 0, 110, 0),
                  //user id checker, if user is not the owner of the question, they have option to answer
                  //if user is owner, they can archive question
                  child: _answerQuestionButton())
              : _questionArchiveButton()),
    );
  }
}

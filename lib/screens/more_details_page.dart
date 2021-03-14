import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';

import 'package:project_eureka_flutter/screens/home_page.dart';

class MoreDetails extends StatefulWidget {
  @override
  _MoreDetailsState createState() => _MoreDetailsState();
}

class _MoreDetailsState extends State<MoreDetails> {
  String id; // user id

  @override
  void initState() {
    initGetQuestionDetails(id);
    super.initState();
  }

  void initGetQuestionDetails(String id) {}

  Column _headerStack() {
    return Column(
      children: [
        Container(
          height: 0,
        ),
        _profileNameAndIcon(),
        _answerQuestion(),
      ],
    );
  }

  Row _profileNameAndIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 55.0,
          backgroundColor: Colors.grey[300],
          child: CircleAvatar(
            radius: 40.0,
            backgroundImage: AssetImage('assets/images/dn.jpg'),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question Title here",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            Text(
              "Technology - Computer Hardware",
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300),
              textAlign: TextAlign.left,
            ),
            Text(
              "Asked : 2 days ago",
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 0, top: 30, right: 0, bottom: 0),
              child: RichText(
                text: TextSpan(
                    // set the default style for the children TextSpans
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Attached media: ',
                      ),
                      TextSpan(
                          text: 'Image1',
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline)),
                      TextSpan(
                        text: '  ',
                      ),
                      TextSpan(
                          text: 'Image2',
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline)),
                    ]),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column _answerQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // add if else statement here : if username logged in matches username of question creator -> _questionArchiveButton() else call _answerQuestionButton()
        SizedBox(
          height: 15.0,
        ),
      ],
    );
  }

  FlatButton _answerQuestionButton() {
    return FlatButton(
      color: Color(0xFF00ADB5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()), // accept question
        );
      },
      child: Container(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Answer this question"),
      )),
    );
  }

  // this button is not visible now. When we connect this page to database,
  // we will check if user is creator of question, and user IS -> they will be shown "Archive question" button
  FlatButton _questionArchiveButton() {
    return FlatButton(
      color: Color(0xFF00ADB5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()), //archive question
        );
      },
      child: Container(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Archive this question"),
      )),
    );
  }

  Container _questionFieldViewer() {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 10),
      height: MediaQuery.of(context).size.height - 405,
      child: SingleChildScrollView(
          child: Text(
              "Long text here which is longer than the container heightLong text"
              " here which is longer than the container heightLong text here"
              " which is longer than the container heightLong text here which"
              " is longer than the container heightLong text here which is "
              "longer than the container heightLong text here which is longer"
              " than the container heightLong text here which is longer than "
              "the container heightLong text here which is longer than the contained"
              " heightLong text here which is longer than the container height"
              "Long text here which is longer than the container heightLong text"
              " here which is longer than the container heightLong text here"
              " which is longer than the container heightLong text here which"
              " is longer than the container heightLong text here which is "
              "longer than the container heightLong text here which is longer"
              " than the container heightLong text here which is longer than "
              "the container heightLong text here which is longer than the container"
              " heightLong text here which is longer than the container height")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EurekaAppBar(
        title: 'Question Details',
        appBar: AppBar(),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.only(left: 3, top: 0, right: 3, bottom: 5),
            alignment: Alignment.topLeft,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            child: Column(
              children: [
                _headerStack(),
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        _questionFieldViewer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _answerQuestionButton(),
        ],
      ),
    );
  }
}

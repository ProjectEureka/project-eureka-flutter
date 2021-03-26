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
  String id;
  String owner_id =
      "abdwk23na1nfaol9fnj35"; // fake user id represents owner of the question
  String user_id =
      "123412313ddd"; // fake user id represents a peer who is checking out question

  //media links mock up
  List<String> links = [
    "Media1 ",
    "Media2 ",
    "Media3 ",
    "Media4 ",
  ];

  Widget _getMediaLinks() {
    return Row(
      children: <Widget>[
        Text(
          'Media: ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        for (var item in links)
          Text(
            item,
            style: TextStyle(
                color: Colors.blue, decoration: TextDecoration.underline),
          ),
        Text(" "),
      ],
    );
  }

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
            Padding(
              padding: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 5),
              child: SizedBox(
                width: 260,
                height: 50,
                child: SingleChildScrollView(
                  child: Text(
                    "Question Title here is very long, and to be honest is sooooo unnecessary , but we are testing fixed size box with scroll, so this field can accommodate freaking essays in the question fields",
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
            Text(
              "Technology - Computer Hardware",
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300),
              textAlign: TextAlign.left,
            ),
            Text(
              "Asked : 2 days ago",
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 0, top: 10, right: 0, bottom: 0),
              child: SizedBox(
                width: 260,
                height: 30,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _getMediaLinks(),
                ),
              ),
            ),
          ],
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
      height: MediaQuery.of(context).size.height - 358,
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
              " here which is longer than the container heightLong text here"
              " here which is longer than the container heightLong text here"
              " which is longer than the container heightLong text here which"
              " is longer than the container heightLong text here which is "
              "longer than the container heightLong text here which is longer"
              " than the container heightLong text here which is longer than "
              "the container heightLong text here which is longer than the container"
              " heightLong text here which is longer than the container height")),
    );
  }

  //user id checker, if user is not the owner of the question, they have option to answer
  //if user is owner, they can archive question
  Widget _answerOrArchiveButton() {
    if (user_id != owner_id) {
      return _answerQuestionButton();
    }
    return _questionArchiveButton();
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
            margin: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0),
            padding: EdgeInsets.only(left: 3, top: 0, right: 3, bottom: 0),
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
                  padding:
                      EdgeInsets.only(left: 2, top: 0, right: 2, bottom: 0),
                  child: _questionFieldViewer(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 110, top: 0, right: 110, bottom: 0),
          child: _answerOrArchiveButton(),
        ),
      ),
    );
  }
}

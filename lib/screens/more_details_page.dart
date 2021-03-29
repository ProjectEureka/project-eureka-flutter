import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/components/eureka_rounded_button.dart';

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
    "pic1.jpg",
    "pic2.jpg",
    "pic3.jpg",
    "pic4.jpg",
    "pic5.jpg",
    "pic6.jpg",
    "pic7.jpg",
    "pic8.jpg",
    "pic9.jpg",
    "pic10.jpg",
    "pic11.jpg",
  ];

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
            for (var item in links)
              FlatButton(
                onPressed: () {},
                child: Text("Media " + (1 + links.indexOf(item)).toString(),
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        decoration: TextDecoration.underline)),
              ),
          ],
        )
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
              padding: EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 10),
            ),
            Row(children: [
              Text(
                "John Van Persie",
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
                " Technology",
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
                " 2 days ago",
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
      // color: Color(0xFF00ADB5),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(20.0),
      // ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()), // accept question
        );
      },
      buttonText: "Answer",
      // child: Container(
      //     child: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Text("Answer this question"),
      // )),
    );
  }

  EurekaRoundedButton _questionArchiveButton() {
    return EurekaRoundedButton(
      // color: Color(0xFF00ADB5),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(20.0),
      // ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()), //archive question
        );
      },
      buttonText: "Archive",
      //   child: Container(
      //       child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Text("Archive this question"),
      //   )
      // ),
    );
  }

  Container _questionFieldViewer() {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 10),
      child: Column(children: [
        Text(
          "Question Title here is very long, and to be honest is sooooo unnecessary , but we are testing fixed size box with scroll, so this field can accommodate freaking essays in the question fields",
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
        Divider(color: Colors.transparent, height: 15.0),
        Text(
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
            "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "
            "when an unknown printer took a galley of type and scrambled it to make a type "
            "specimen book. It has survived not only five centuries, but also the leap into"
            " electronic typesetting, remaining essentially unchanged. It was popularised in"
            " the 1960s with the release of Letraset sheets containing "
            "Lorem Ipsum passages, and more recently with desktop publishing software "
            "like Aldus PageMaker including versions of Lorem Ipsum."),
        Divider(color: Colors.transparent, height: 15.0),
        _getMediaLinks()
      ]),
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
      body: ListView(
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

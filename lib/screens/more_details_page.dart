import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/components/side_menu.dart';

class MoreDetails extends StatefulWidget {
  @override
  _MoreDetailsState createState() => _MoreDetailsState();
}

class _MoreDetailsState extends State<MoreDetails> {
  String questionsDetails; // variable for question text
  String id; // user id

  @override
  void initState() {
    initGetQuestionDetails(id);
    super.initState();
  }

  void initGetQuestionDetails(String id) {}

  Stack _headerStack() {
    return Stack(
      children: [
        Container(
          height: 300.0,
        ),
        EurekaAppBar(
          title: 'Question Details',
          appBar: AppBar(),
        ),
        _profileNameAndIcon(),
        _answerQuestion(),
        //_questionField(),
      ],
    );
  }

  Positioned _profileNameAndIcon() {
    return Positioned(
      top: 140.0,
      left: 15.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 55.0,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage('assets/images/dn.jpg'),
            ),
          ),
          Text(
            "Mr Pickles",
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
          Text(
            "tonynguyen0925@gmail.com",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
        ],
      ),
    );
  }

  Positioned _answerQuestion() {
    return Positioned(
      top: 200.0,
      right: 15.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // add if else statement here : if username logged in matches username of question creator -> _questionArchiveButton() else call _answerQuestionButton()
          _answerQuestionButton(),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
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
          MaterialPageRoute(
              builder: (context) => MoreDetails()), // accept question
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
          MaterialPageRoute(
              builder: (context) => MoreDetails()), //archive question
        );
      },
      child: Container(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Archive this question"),
      )),
    );
  }

  Column _questionFieldViewer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: Text('Is this a question title???',
              style: TextStyle(
                  fontWeight: FontWeight.bold, height: 5, fontSize: 15)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: Text(
              'We move under cover and we move as one'
              'Through the night, we have one shot to live another day'
              'We cannot let a stray gunshot give us away'
              'We will fight up close, seize the moment and stay in it'
              'It’s either that or meet the business end of a bayonet'
              'The code word is ‘Rochambeau,’ dig me?',
              style: TextStyle()),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: Text('Media attached: ',
              style: TextStyle(
                  fontWeight: FontWeight.bold, height: 5, fontSize: 15)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: Text('image_1.jpg',
              style: TextStyle(
                  fontSize: 12, decoration: TextDecoration.underline)),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      body: Column(
        children: [
          _headerStack(),
          _questionFieldViewer(),
        ],
      ),
    );
  }
}

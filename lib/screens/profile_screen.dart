import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/components/eureka_list_view.dart';
import 'package:project_eureka_flutter/components/eureka_toggle_switch.dart';
import 'package:project_eureka_flutter/components/profile_answers_list.dart';
import 'package:project_eureka_flutter/components/side_menu.dart';
import 'package:project_eureka_flutter/models/user_model.dart';
import 'package:project_eureka_flutter/screens/profile_onboarding_screen.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';
import 'package:project_eureka_flutter/services/profile_service.dart';

class Profile extends StatefulWidget {
  final notSideMenu;
  final userId;

  Profile({this.userId, this.notSideMenu});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _tab = 0;
  List questionsList = [];
  List answersList = [];
  UserModel userInfo = UserModel();
  List categories = [];
  bool loading = true;
  int bestAnswersCount = 0;

  final User currentUser = EmailAuth().getCurrentUser();

  @override
  void initState() {
    initGetProfileData();
    super.initState();
  }

  void initGetProfileData() {
    ProfileService()
        .getProfileInformation(
            widget.notSideMenu == null ? currentUser.uid : widget.userId)
        .then(
      (payload) {
        setState(() {
          questionsList = payload[0];
          answersList = payload[1];
          userInfo = payload[2];
          categories = userInfo.category;
          loading = false;
          answersList.forEach((answer) {
            if(answer.bestAnswer){
              bestAnswersCount += 1;
            }
          });
        });
      },
    );
  }

  Center _noResults(String message) {
    return loading
        ? Center(child: CircularProgressIndicator())
        : Center(
            child: Text(userInfo.firstName + message),
          );
  }

  Positioned _profileNameAndIcon() {
    return Positioned(
      top: 120.0,
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
              backgroundColor: Colors.transparent,
              backgroundImage: loading
                  ? AssetImage('assets/images/profile_default_image.png')
                  : userInfo.pictureUrl == ""
                      ? AssetImage('assets/images/profile_default_image.png')
                      : NetworkImage(userInfo.pictureUrl),
            ),
          ),
          loading
              ? Text("")
              : Text(userInfo.firstName + " " + userInfo.lastName,
                  style:
                      TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
          loading
              ? Text("")
              : Text(
                  userInfo.email,
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
        ],
      ),
    );
  }

  FlatButton _editProfileButton() {
    return FlatButton(
      color: Color(0xFF00ADB5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileOnboarding(
              isProfile: true,
              user: userInfo,
            ),
          ),
        );
      },
      child: Container(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Edit Profile"),
      )),
    );
  }

  Positioned _editButtonAndRating() {
    return Positioned(
      top: 190.0,
      right: 15.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if ((widget.userId == currentUser.uid) | (widget.userId == null))
            _editProfileButton(),
          SizedBox(
            height: 7.0,
          ),
          loading
              ? Text("Best Answers: -", style: TextStyle(fontWeight: FontWeight.bold))
              : Text("Best Answers: " +
              bestAnswersCount.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 7.0,
          ),
          loading
              ? Text("-.- ⭐", style: TextStyle(fontWeight: FontWeight.bold))
              : userInfo.averageRating == 0.0
                  ? Text("Not rated yet ⭐", style: TextStyle(fontWeight: FontWeight.bold))
                  : Text(
                      userInfo.averageRating.toString() + " ⭐",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
        ],
      ),
    );
  }

  Stack _headerStack() {
    return Stack(
      children: [
        /// forces the stack to be a min height of 300.0
        Container(
          height: 300.0,
        ),
        EurekaAppBar(
          title: 'Profile',
          appBar: AppBar(),
          actions: widget.notSideMenu == null
              ? null
              : [
                  IconButton(
                      icon: Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (Route<void> route) => false)),
                  SizedBox(width: 15)
                ],
        ),
        _profileNameAndIcon(),
        _editButtonAndRating(),
      ],
    );
  }

  Column _toggleSwtichListBuilder(int itemCount, ListView listView) {
    return Column(
      children: <Widget>[
        Center(
          child: Container(
            /// screen height minus total size of profile stack
            height: MediaQuery.of(context).size.height - 360,
            child: listView,
          ),
        )
      ],
    );
  }

  Column _questionsList() {
    return _toggleSwtichListBuilder(
      questionsList.length,
      ListView.builder(
        padding: EdgeInsets.all(0.0),
        itemCount: questionsList.length,
        itemBuilder: (context, index) {
          return EurekaListView(
            questionList: questionsList,
            index: index,
          );
        },
      ),
    );
  }

  Column _answersList() {
    return _toggleSwtichListBuilder(
      answersList.length,
      ListView.builder(
        padding: EdgeInsets.all(0.0),
        itemCount: answersList.length,
        itemBuilder: (context, index) {
          return ProfileAnswersView(
            answersList: answersList,
            index: index,
          );
        },
      ),
    );
  }

  Column _listVisibility() {
    return Column(
      children: [
        Visibility(
          visible: _tab == 0 ? true : false,
          child: questionsList.length == 0
              ? _noResults(" have not posted any questions yet")
              : _questionsList(),
        ),
        Visibility(
          visible: _tab == 1 ? true : false,
          child: answersList.length == 0
              ? _noResults(" have not answered to any questions yet")
              : _answersList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.notSideMenu == null ? SideMenu() : null,
      body: Column(
        children: [
          _headerStack(),
          EurekaToggleSwitch(
            labels: ['Questions', 'Answers'],
            initialLabelIndex: _tab,
            setState: (index) {
              setState(() {
                _tab = index;
              });
            },
          ),
          _listVisibility(),
        ],
      ),
    );
  }
}

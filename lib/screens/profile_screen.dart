import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/components/eureka_list_view.dart';
import 'package:project_eureka_flutter/components/eureka_toggle_switch.dart';
import 'package:project_eureka_flutter/components/profile_answers_list.dart';
import 'package:project_eureka_flutter/screens/profile_onboarding.dart';
import 'package:project_eureka_flutter/services/user_category_service.dart';
import 'package:project_eureka_flutter/services/profile_service.dart';
import 'package:project_eureka_flutter/components/side_menu.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _tab = 0;
  List questionsList = [];
  List answersList = [];
  List categories = [];
  String firstName = ""; // this will be changed later
  bool loading = true;

  @override
  void initState() {
    initGetProfileInfo();
    initGetActiveCategories();
    super.initState();
  }

  void initGetProfileInfo() {
    ProfileService().getProfileInformation().then(
      (payload) {
        setState(() {
          questionsList = payload[0];
          answersList = payload[1];
          firstName = payload[2];
          loading = false;
        });
      },
    );
  }

  void initGetActiveCategories() {
    UserCategoryService().getCategories().then(
      (payload) {
        setState(() {
          categories = payload;
        });
      },
    );
  }

  Center _noResults(String message) {
    return loading
        ? Center(child: CircularProgressIndicator())
        : Center(
            child: Text(message),
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
              backgroundImage: AssetImage('assets/images/money.gif'),
            ),
          ),
          Text(
            "Tony Nguyen",
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
          Text(
            "tonynguyen0925@gmail.com",
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
          _editProfileButton(),
          SizedBox(
            height: 15.0,
          ),
          Text(
            "5.0 ⭐",
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
            filteredQuestionsList: questionsList,
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

  Widget _categoryBuilder(int index) {
    return Column(
      children: [
        ListTile(
          leading: Image.asset(
              'assets/images/${categories[index].toLowerCase()}.png'),
          title: Text(
            '${categories[index]}',
          ),
        ),
        Divider(color: Colors.grey.shade400, height: 1.0)
      ],
    );
  }

  Column _interestList() {
    return _toggleSwtichListBuilder(
      categories.length,
      ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return _categoryBuilder(index);
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
              ? _noResults(firstName + " have not posted any questions yet")
              : _questionsList(),
        ),
        Visibility(
          visible: _tab == 1 ? true : false,
          child: answersList.length == 0
              ? _noResults(firstName + " have not answered to any questions yet")
              : _answersList(),
        ),
        Visibility(
          visible: _tab == 2 ? true : false,
          child: _interestList(),
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
          EurekaToggleSwitch(
            labels: ['Questions', 'Answers', 'Interests'],
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

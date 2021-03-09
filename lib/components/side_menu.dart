import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/screens/home_page.dart';
import 'package:project_eureka_flutter/screens/new_question_screens/new_question_screen.dart';
import 'package:project_eureka_flutter/screens/profile_screen.dart';
import 'package:project_eureka_flutter/screens/settings_screen.dart';
import 'package:project_eureka_flutter/screens/test_CRUD.dart';

class SideMenu extends StatelessWidget {
  final String title;
  SideMenu({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(children: <Widget>[
      UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blueGrey[800],
        ),
        accountName: Text('Tony N.', style: TextStyle(fontSize: 18.0)),
        accountEmail: Text('tonynguyen@gmail.com'),
        currentAccountPicture: CircleAvatar(backgroundColor: Colors.teal),
      ),
      sideMenuListTile(context, 'Home', Home(), Icons.home),
      Divider(color: Colors.grey.shade400, height: 1.0),
      sideMenuListTile(
        context,
        'Profile',
        ProfileScreen(),
        Icons.person,
      ),
      Divider(color: Colors.grey.shade400, height: 1.0),
      sideMenuListTile(
        context,
        'Create New Post',
        NewQuestionScreen(),
        Icons.edit,
      ),
      Divider(color: Colors.grey.shade400, height: 1.0),
      sideMenuListTile(
        context,
        'Settings',
        SettingsScreen(),
        Icons.settings,
      ),
      Divider(color: Colors.grey.shade400, height: 1.0),
          sideMenuListTile(
            context,
            'Test CRUD',
            TestSpring(),
            Icons.info,
          ),
          Divider(color: Colors.grey.shade400, height: 1.0),
    ]));
  }
}

ListTile sideMenuListTile(
    BuildContext context, String string, Widget newScreen, IconData leading) {
  return ListTile(
      title: Text(string, style: TextStyle(fontSize: 16.0)),
      leading: Icon(leading, size: 27.0),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (BuildContext context) => newScreen));
      });
}

import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/screens/home_page.dart';
import 'package:project_eureka_flutter/screens/new_question_screen.dart';
import 'package:project_eureka_flutter/screens/profile_screen.dart';
import 'package:project_eureka_flutter/screens/settings_screen.dart';

class SideMenu extends StatelessWidget {
  final String title;
  SideMenu({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Home'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            sideMenuListTile(context, 'Home', Home()),
            sideMenuListTile(context, 'Profile', ProfileScreen()),
            sideMenuListTile(context, 'Create New Post', NewQuestionScreen()),
            sideMenuListTile(context, 'Settings', SettingsScreen()),
          ],
        ),
      ),
    );
  }
}

ListTile sideMenuListTile(
    BuildContext context, String string, Widget newScreen) {
  return ListTile(
      title: Text(string),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => newScreen),
        );
      });
}

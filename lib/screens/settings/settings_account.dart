import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/screens/settings/account/account_settings_delete.dart';
import 'package:project_eureka_flutter/screens/settings/account/account_settings_email.dart';
import 'package:project_eureka_flutter/screens/settings/account/account_settings_password.dart';

class SettingsAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Account"),
        toolbarHeight: 100,
        backgroundColor: Color(0xFF37474F),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10, top: 3, right: 10),
        child: ListView(
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(horizontal: 17, vertical: 20),
                child: Text(
                  'Personal Information',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                )),
            Divider(height: 1.0),
            accountSettingsListTile(context, CupertinoIcons.envelope_fill,
                'Email', AccountSettingsEmail()),
            Divider(height: 1.0),
            accountSettingsListTile(context, CupertinoIcons.lock_fill,
                'Password', AccountSettingsPassword()),
            Divider(height: 1.0),
            accountSettingsListTile(context, CupertinoIcons.trash_fill,
                'Delete Account', AccountSettingsDelete()),
            Divider(height: 1.0),
          ],
        ),
      ),
    );
  }
}

ListTile accountSettingsListTile(
    BuildContext context, IconData icon, String string, Widget newScreen) {
  return ListTile(
    leading: Icon(icon),
    title: Text(string),
    trailing: Icon(Icons.keyboard_arrow_right),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => newScreen),
      );
    },
  );
}

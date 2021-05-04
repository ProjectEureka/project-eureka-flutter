import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/components/side_menu.dart';
import 'package:project_eureka_flutter/screens/settings/settings_account.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';

class Settings extends StatelessWidget {
  final EmailAuth _emailAuth = EmailAuth();

  final String title = 'Settings';

  ListTile settingsListTile(
      BuildContext context, IconData icon, String string, Widget newScreen) {
    return ListTile(
      leading: Icon(icon, size: 30.0),
      title: Text(string, style: TextStyle(fontSize: 18.0)),
      trailing: Icon(newScreen == null ? null : Icons.keyboard_arrow_right),
      onTap: () {
        newScreen == null
            ? showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('About EureQa'),
                    content: Text(
                      'EureQa is an app where users can provide help or request help through a system of answers and questions. Users will be able to connect live with each other, through our chat and video call system.',
                      textAlign: TextAlign.center,
                    ),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Close')),
                    ],
                  );
                })
            : Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => newScreen),
              );
      },
    );
  }

  void signOut(context) {
    _emailAuth.signOut().then((_) => Navigator.pushNamedAndRemoveUntil(
        context, '/', (Route<void> route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: EurekaAppBar(
        title: 'Settings',
        appBar: AppBar(),
      ),
      body: ListView(
        children: <Widget>[
          settingsListTile(
              context, CupertinoIcons.person_alt, 'Account', SettingsAccount()),
          Divider(height: 1.0),
          ListTile(
            leading: Icon(CupertinoIcons.square_arrow_right, size: 30.0),
            title: Text('Logout', style: TextStyle(fontSize: 18.0)),
            onTap: () {
              signOut(context);
            },
          ),
          Divider(height: 1.0),
          settingsListTile(context, CupertinoIcons.info_circle, 'About', null),
        ],
      ),
    );
  }
}

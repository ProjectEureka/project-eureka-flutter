import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/components/side_menu.dart';
import 'package:project_eureka_flutter/screens/settings/settings_account.dart';
import 'package:project_eureka_flutter/screens/settings/settings_general.dart';
import 'package:project_eureka_flutter/screens/settings/settings_payment.dart';
import 'package:project_eureka_flutter/services/sign_in.dart';
import 'package:project_eureka_flutter/screens/login_page.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Settings';

    return Scaffold(
      drawer: SideMenu(),
      appBar: EurekaAppBar(
        title: 'Settings',
        appBar: AppBar(),
      ),
      /*appBar: AppBar(
        title: Text(title),
        toolbarHeight: 100,
        backgroundColor: Color(0xFF37474F),
      ),*/
      body: ListView(
        children: <Widget>[
          settingsListTile(context, CupertinoIcons.gear_alt_fill, 'General',
              SettingsGeneral()),
          Divider(height: 1.0),
          settingsListTile(context, CupertinoIcons.creditcard_fill, 'Payment',
              SettingsPayment()),
          Divider(height: 1.0),
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
        ],
      ),
    );
  }
}

ListTile settingsListTile(
    BuildContext context, IconData icon, String string, Widget newScreen) {
  return ListTile(
    leading: Icon(icon, size: 30.0),
    title: Text(string, style: TextStyle(fontSize: 18.0)),
    trailing: Icon(Icons.keyboard_arrow_right),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => newScreen),
      );
    },
  );
}

void signOut(context) {
  signOutGoogle().then((_) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<Widget>(builder: (BuildContext context) => LoginPage()),
      (Route<void> route) => false));
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/components/side_menu.dart';
import 'package:project_eureka_flutter/screens/settings/settings_account.dart';
import 'package:project_eureka_flutter/screens/settings/settings_general.dart';
import 'package:project_eureka_flutter/screens/settings/settings_payment.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';
import 'package:project_eureka_flutter/screens/login_page.dart';

class SettingsScreen extends StatelessWidget {
  final EmailAuth _emailAuth = new EmailAuth();

  final String title = 'Settings';

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
    _emailAuth.signOut().then((_) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<Widget>(
            builder: (BuildContext context) => LoginPage()),
        (Route<void> route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: EurekaAppBar(
        title: 'Settings',
        appBar: AppBar(),
        toolbarHeight: 100,
      ),
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

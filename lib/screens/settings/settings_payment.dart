import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/screens/settings/payment/apple_pay.dart';
import 'package:project_eureka_flutter/screens/settings/payment/google_pay.dart';

class SettingsPayment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EurekaAppBar(
        title: 'Payment Settings',
        appBar: AppBar(),
      ),
      body: ListView(
        children: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 20),
              child: Text(
                'Payment Methods',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              )),
          Divider(height: 5.0),
          settingsListTile(
              context,
              AssetImage('assets/images/Google_Pay_Logo.png'),
              'Google Pay',
              GooglePay()),
          Divider(height: 5.0),
          settingsListTile(
              context,
              AssetImage('assets/images/Apple_Pay_logo.png'),
              'Apple Pay',
              ApplePay()),
          Divider(height: 5.0),
        ],
      ),
    );
  }
}

ListTile settingsListTile(
    BuildContext context, AssetImage image, String string, Widget newScreen) {
  return ListTile(
    leading: Container(
        padding: EdgeInsets.all(7.0),
        child: Image(image: image, width: 55.0),
        decoration: BoxDecoration(border: Border.all())),
    title: Text(string,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
    trailing: Icon(Icons.keyboard_arrow_right, size: 30.0),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => newScreen),
      );
    },
  );
}

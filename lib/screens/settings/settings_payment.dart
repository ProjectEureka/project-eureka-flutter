import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/screens/settings/payment/apple_pay.dart';
import 'package:project_eureka_flutter/screens/settings/payment/google_pay.dart';

class SettingsPayment extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Settings"),
        toolbarHeight: 100,
        backgroundColor: Color(0xFF37474F),
      ),
      body: ListView(
        children: <Widget>[
          Container(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30), child: Text('Payment Methods', style: TextStyle(color: Colors.blue, fontSize: 20.0, fontWeight: FontWeight.bold), textAlign: TextAlign.left,)),
          settingsListTile(context, AssetImage('assets/images/Google_Pay_Logo.png'), 'Google Pay', GooglePay()),
          Divider(height: 30.0),
          settingsListTile(context, AssetImage('assets/images/Apple_Pay_logo.png'), 'Apple Pay', ApplePay()),
          Divider(height: 10.0),
        ],
      ),
    );
  }
}

ListTile settingsListTile(
    BuildContext context, AssetImage image, String string, Widget newScreen) {
  return ListTile(
    leading: Container(padding: EdgeInsets.all(7.0), child: Image(image: image, width: 70.0), decoration: BoxDecoration(border: Border.all())),
    title: Text(string, textAlign: TextAlign.left, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
    trailing: Icon(Icons.keyboard_arrow_right, size: 50.0),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => newScreen),
      );
    },
  );
}

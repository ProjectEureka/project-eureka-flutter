import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/screens/settings/payment/apple_pay.dart';
import 'package:project_eureka_flutter/screens/settings/payment/google_pay.dart';

class SettingsPayment extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final title = 'Settings';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        children: <Widget>[
          Divider(height: 20.0),
          Text('Payment Methods', style: TextStyle(color: Colors.blue, fontSize: 30.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
          Divider(height: 50.0),
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
    leading: Container(padding: EdgeInsets.all(10.0), child: Image(image: image, width: 100.0), decoration: BoxDecoration(border: Border.all())),
    title: Text(string, textAlign: TextAlign.center, style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
    trailing: Icon(Icons.keyboard_arrow_right, size: 50.0),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => newScreen),
      );
    },
  );
}

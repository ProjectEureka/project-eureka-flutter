import 'package:flutter/material.dart';

class PaymentConfirmation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var count = 0;
    return Scaffold(
        body: AlertDialog(
      title: Text(
        'Thank you!',
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: Text(
        'Consequat velit qui adipisicing sunt do reprehenderit ad laborum tempor ullamco exercitation. Ullamco tempor adipisicing et voluptate duis sit esse aliqua esse ex dolore esse. Consequat velit qui adipisicing sunt.',
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.popUntil(context, (route) {
                  // pop the last 2 routes to get back to payment settings
                  return count++ == 2;
                }),
            child: Text('Close')),
      ],
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/screens/settings/payment/payment_confirmation.dart';

class GooglePay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Pay"),
        toolbarHeight: 100,
        backgroundColor: Color(0xFF37474F),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PaymentConfirmation()),
            );
          },
          child: Text('Confirm'),
        ),
      ),
    );
  }
}

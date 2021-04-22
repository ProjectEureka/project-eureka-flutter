import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';

class GooglePay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EurekaAppBar(
        title: 'Google Pay',
        appBar: AppBar(),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/paymentConfirmation');
          },
          child: Text('Confirm'),
        ),
      ),
    );
  }
}

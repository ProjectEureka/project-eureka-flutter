import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';

class SettingsAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EurekaAppBar(
        title: 'Account Settings',
        appBar: AppBar(),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

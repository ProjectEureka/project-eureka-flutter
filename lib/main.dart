import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/screens/profile_onboarding.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Project Eureka';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProfileOnboarding(),
      debugShowCheckedModeBanner: false,
    );
  }
}

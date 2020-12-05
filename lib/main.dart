import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/profile-onboarding.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProfileOnboarding(),
      debugShowCheckedModeBanner: false,
    );
  }
}

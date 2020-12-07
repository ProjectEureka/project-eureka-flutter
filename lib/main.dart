import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/side_menu.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final appTitle = 'Project Eureka';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: SideMenu(title: appTitle),
    );
  }
}

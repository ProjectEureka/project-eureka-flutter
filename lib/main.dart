import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/side_menu.dart';

void main() => runApp(ProjectEureka());

class ProjectEureka extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Project Eureka';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SideMenu(title: appTitle),
      debugShowCheckedModeBanner: false,
    );
  }
}

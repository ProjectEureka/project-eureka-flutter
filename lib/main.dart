import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/screens/root_page.dart';

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
      debugShowCheckedModeBanner: false,
      home: RootPage(),
    );
  }
}

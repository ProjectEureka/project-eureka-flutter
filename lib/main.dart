import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/screens/root_screen.dart';
import 'package:project_eureka_flutter/services/route_generator.dart';

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
      home: RootScreen(),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

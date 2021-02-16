import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/side_menu.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: Text('Profile'),
        toolbarHeight: 100,
        backgroundColor: Color(0xFF37474F),
      ),
    );
  }
}

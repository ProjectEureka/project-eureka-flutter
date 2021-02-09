import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/side_menu.dart';

class NewPostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: Text('New Post Screen'),
        toolbarHeight: 100,
        backgroundColor: Color(0xFF37474F),
      ),
    );
  }
}

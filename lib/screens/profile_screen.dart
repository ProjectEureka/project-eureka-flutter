import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/components/side_menu.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideMenu(),
        //toolbarHeight: 100,
        //widgets: <Widget>[Icon(Icon.more_vert)],

        body: Container());
  }
}

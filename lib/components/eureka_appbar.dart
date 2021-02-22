import 'package:flutter/material.dart';

/*This is a custom made AppBar made specifically for Project
 Eureka. Please use this Widget when implementing an appbar in our pages, so
 we can have a uniform design though out our app.*/

class EurekaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final AppBar appBar;

  const EurekaAppBar(
      {@required this.title, this.actions, @required this.appBar});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Color(0xFF37474F),
      centerTitle: true,
      toolbarHeight: 100,
      actions: actions == null ? null : actions,
    );
  }

  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}

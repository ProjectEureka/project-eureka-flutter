import 'package:flutter/material.dart';

class AccountSettingsDelete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delete Your Account"),
        toolbarHeight: 100,
        backgroundColor: Color(0xFF37474F),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: ListView(
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(horizontal: 17, vertical: 20),
                child: Text(
                  'This will delete your account',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                )),
            Divider(color: Colors.grey.shade400, height: 1.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
              child: Text(
                "You're about to start the process of deleting your account. Your display name and profile will no longer be viewable on Project Eureka.",
                style: TextStyle(color: Colors.black, fontSize: 17.0),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                child: Text(
                  'What else you should know',
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                )),
            Divider(color: Colors.grey.shade400, height: 1.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
              child: Text(
                "If you just want to change your personal information, you don't need to delete your account -- you can edit it in your Account Settings.",
                style: TextStyle(color: Colors.black, fontSize: 17.0),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 275),
            Container(
              padding: EdgeInsets.all(18.0),
              child: FlatButton(
                color: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                onPressed: () {},
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Delete account',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 21.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/components/eureka_rounded_button.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';

class AccountSettingsDelete extends StatelessWidget {
  final EmailAuth _emailAuth = new EmailAuth();

  void deleteUserAccount(context) {
    _emailAuth
        .deleteUser()
        .then((_) => Navigator.of(context).pushNamed('/signIn'));
  }

  Text _textStyling(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.black, fontSize: 17.0),
      textAlign: TextAlign.left,
    );
  }

  Container _accountContainers(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      child: _textStyling(text),
    );
  }

  Container _deleteAccountInfo() {
    return Container(
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
            ),
          ),
          Divider(color: Colors.grey.shade400, height: 1.0),
          _accountContainers(
              "You're about to start the process of deleting your account. Your display name and profile will no longer be viewable on Project Eureka. However, your questions and answers posts will remain."),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 20),
              child: Text(
                'What else you should know',
                style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              )),
          Divider(color: Colors.grey.shade400, height: 1.0),
          _accountContainers(
              "If you just want to change your personal information, you don't need to delete your account -- you can edit it in your Account Settings."),
        ],
      ),
    );
  }

  Future<dynamic> _showDialog(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Are you sure?"),
            content: Text(
                "You will permanently lose your account and this proccess cannot be undone."),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  deleteUserAccount(context);
                },
                child: Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          );
        });
  }

  EurekaRoundedButton _deleteAccountButton(context) {
    return EurekaRoundedButton(
      buttonText: "Delete Account",
      onPressed: () => _showDialog(context),
      buttonColor: Colors.grey[300],
      textColor: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EurekaAppBar(
        title: "Delete Your Account",
        appBar: AppBar(),
      ),
      body: _deleteAccountInfo(),
      bottomNavigationBar: _deleteAccountButton(context),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/components/eureka_rounded_button.dart';
import 'package:project_eureka_flutter/screens/login_page.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';
import 'package:project_eureka_flutter/services/google_auth.dart';
import 'package:project_eureka_flutter/services/delete_user_service.dart';
import 'package:project_eureka_flutter/services/firebase_exception_handler.dart';

class AccountSettingsDelete extends StatefulWidget {
  @override
  _AccountSettingsDeleteState createState() => _AccountSettingsDeleteState();
}

class _AccountSettingsDeleteState extends State<AccountSettingsDelete> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final EmailAuth _emailAuth = new EmailAuth();

  String _password;

  String providerId = EmailAuth().getCurrentUser().providerData[0].providerId;

  String exception = "";

  Future<void> deleteUserAccount(context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    if (providerId == "password") {
      _formKey.currentState.save();
    }
    try {
      String tempId = EmailAuth().getCurrentUser().uid;
      if (providerId == "password") {
        await _emailAuth.deleteUser(_password);
      } else if (providerId == "google.com") {
        await GoogleAuth().deleteUser();
      }
      await DeleteUserService().deleteUser(tempId);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<Widget>(
              builder: (BuildContext context) => LoginPage()),
          (Route<void> route) => false);
    } catch (e) {
      setState(() {
        exception = FirebaseExceptionHandler().getExceptionText(e);
      });
      print('this is e: ' + exception);
    }
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

  Future<dynamic> _showDialog(context, _exception) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Are you sure?"),
            content: Column(
              children: [
                Text(
                    "You will permanently lose your account and this proccess cannot be undone."),
                providerId == "google.com"
                    ? Container()
                    : Form(
                        key: _formKey,
                        child: TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xF6F6F6F6),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[200]),
                            ),
                            labelText: 'Enter Password',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _password = value.trim();
                          },
                        ),
                      ),
                Visibility(
                  /* visible: exception == "" ? false : true,*/
                  visible: true,
                  child: Text(
                    _exception,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                )
              ],
            ),
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
                onPressed: () => deleteUserAccount(context),
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
      onPressed: () => _showDialog(context, exception),
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

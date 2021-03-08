import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/components/eureka_rounded_button.dart';
import 'package:project_eureka_flutter/components/eureka_text_form_field.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';
import 'package:project_eureka_flutter/services/firebase_exception_handler.dart';

class AccountSettingsPassword extends StatefulWidget {
  @override
  _AccountSettingsPasswordState createState() =>
      _AccountSettingsPasswordState();
}

class _AccountSettingsPasswordState extends State<AccountSettingsPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RegExp _passwordValid =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  FirebaseExceptionHandler _exceptionHandler = new FirebaseExceptionHandler();
  EmailAuth _emailAuth = new EmailAuth();

  String currentPassword;
  String newPassword;
  String rePassword;
  String exception = "";

  Future<void> updateUserPassword(context) async {
    await _emailAuth.updatePassword(currentPassword, newPassword);
    _showDialog(context);
  }

  Future<void> _validateAndSubmit(context) async {
    _formKey.currentState.save();
    if (!_formKey.currentState.validate()) {
      return;
    }
    try {
      await updateUserPassword(context);
    } catch (e) {
      setState(() {
        exception = _exceptionHandler.getExceptionText(e);
        print(exception);
      });
    }
  }

  Future<dynamic> _showDialog(context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Password changed"),
          content: Text("You can now sign in with your new password."),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                "Done",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF00ADB5),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Container _passwordTextForm() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                child: Text(
                  'What would you like to change your current password to? ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10.0),
              Visibility(
                visible: exception == "" ? false : true,
                child: Text(
                  exception,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(height: 7),
              EurekaTextFormField(
                obscureText: true,
                labelText: "Current password",
                errValidatorMsg: "Password required.",
                regExp: _passwordValid,
                onSaved: (value) => currentPassword = value.trim(),
              ),
              EurekaTextFormField(
                obscureText: true,
                labelText: "New Password",
                errValidatorMsg: "Password required.",
                regExp: _passwordValid,
                onSaved: (value) => newPassword = value.trim(),
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Re-enter new password"),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Password required.";
                  } else if (newPassword != value) {
                    return "Passwords do not match";
                  }
                  return null;
                },
                onSaved: (value) => rePassword = value.trim(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _updatePasswordButton(context) {
    return Container(
      child: EurekaRoundedButton(
        buttonText: "Change password",
        onPressed: () => _validateAndSubmit(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EurekaAppBar(
        title: "Update Password",
        appBar: AppBar(),
      ),
      body: _passwordTextForm(),
      bottomNavigationBar: _updatePasswordButton(context),
    );
  }
}

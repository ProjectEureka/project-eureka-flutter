import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/eureka_rounded_button.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';

class AccountSettingsPassword extends StatefulWidget {
  @override
  _AccountSettingsPasswordState createState() =>
      _AccountSettingsPasswordState();
}

class _AccountSettingsPasswordState extends State<AccountSettingsPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  EmailAuth _emailAuth = new EmailAuth();
  String password;

  void updatePassword(context) {
    _emailAuth.updatePassword(password).then((_) => Navigator.pop(context));
  }

  void _validateAndSubmit(context) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    print("new password: " + password);
    updatePassword(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Password"),
        toolbarHeight: 100,
        backgroundColor: Color(0xFF37474F),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10.0),
                Container(
                  padding: EdgeInsets.all(10.0),
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
                //current password
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Current password"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Password required.";
                    } else {
                      password = value;
                      return null;
                    }
                  },
                  onSaved: (value) => password = value.trim(),
                ),
                SizedBox(height: 10.0),
                //new password
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "New password"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Password required.";
                    } else {
                      password = value;
                      return null;
                    }
                  },
                  onSaved: (value) => password = value.trim(),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Re-type new password"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Password required.';
                    } else if (password != value) {
                      return 'Passwords do not match.';
                    }
                    password = value;
                    return null;
                  },
                  onSaved: (value) => password = value.trim(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: EurekaRoundedButton(
          onPressed: () => _validateAndSubmit(context),
          buttonText: 'Done',
        ),
      ),
    );
  }
}

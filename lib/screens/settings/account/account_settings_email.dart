import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/eureka_rounded_button.dart';
import 'package:project_eureka_flutter/components/eureka_text_form_field.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';

class AccountSettingsEmail extends StatefulWidget {
  @override
  _AccountSettingsEmailState createState() => _AccountSettingsEmailState();
}

class _AccountSettingsEmailState extends State<AccountSettingsEmail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final EmailAuth _emailAuth = new EmailAuth();
  String email;
  static final RegExp _regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  void updateUserEmail(context) {
    _emailAuth.updateEmail(email).then((_) => Navigator.pop(context));
  }

  void _validateAndSubmit(context) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    updateUserEmail(context);
  }

  Container _emailTextForm() {
    return Container(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'What would you like to change your email to?',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )),
              EurekaTextFormField(
                labelText: "Email",
                errValidatorMsg: "Email required.",
                regExp: _regExp,
                onSaved: (value) => email = value.trim(),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Email"),
        toolbarHeight: 100,
        backgroundColor: Color(0xFF37474F),
      ),
      body: _emailTextForm(),
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

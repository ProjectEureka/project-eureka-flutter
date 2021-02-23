import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';
import 'package:project_eureka_flutter/services/firebase_exception_handler.dart';

import 'login_page.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  EmailAuth _emailAuth = new EmailAuth();
  FirebaseExceptionHandler _firebaseExceptionHandler =
      new FirebaseExceptionHandler();

  String _userEmail;
  String _password;
  String exception = "";

  final RegExp _emailValid = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  final RegExp _passwordValid =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  void _validateAndSubmit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    try {
      _emailAuth.signUp(_userEmail, _password).then((newUser) {
        if (newUser != null) {
          Navigator.pop(
            context,
            MaterialPageRoute(
              builder: (context) {
                return LoginPage();
              },
            ),
          );
        }
      });
    } catch (e) {
      setState(() {
        exception = _firebaseExceptionHandler.getExceptionText(e);
      });
    }
  }

  Widget _form(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Email needed';
                } else if (!_emailValid.hasMatch(value)) {
                  return 'You must enter a valid email address';
                }
                _userEmail = value.trim();
                return null;
              },
              textAlign: TextAlign.center,
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Password Needed';
                }
                _password = value;
                return null;
              },
              textAlign: TextAlign.center,
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Confirm Password',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Retype Password';
                } else if (_password != value) {
                  return 'Password does not match';
                }
                _password = value;
                return null;
              },
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () => _validateAndSubmit(),
                child: Text('Register'),
              ),
            ),
          ],
        ));
  }

  Widget _back(BuildContext context) {
    return ElevatedButton(
      child: Text('Return to login'),
      onPressed: () {
        Navigator.pop(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LoginPage();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _form(context),
              Visibility(
                visible: exception == "" ? false : true,
                child: Text(
                  exception,
                  style: TextStyle(color: Colors.red),
                ),
              ),
              _back(context),
            ],
          ),
        ),
      ),
    );
  }
}

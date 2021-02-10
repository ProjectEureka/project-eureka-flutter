import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:project_eureka_flutter/screens/home_page.dart';
import 'package:project_eureka_flutter/services/auth.dart';

import 'login_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _userEmail;
  String _password;
  String exception = "";
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
                  )),
              _back(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _form(BuildContext context) {
    final RegExp _emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    final RegExp _passwordValid =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    RegExp regExp;
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
                _userEmail = value;
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
                onPressed: () async {
                  print('in pressed');
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: _userEmail, password: _password);
                      //print('signInWithGoogle succeeded, uid displayed: ${newUser.uid}');
                      print(_userEmail);
                      if (newUser != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return HomePage();
                            },
                          ),
                        );
                      }
                    } catch (e) {
                      setState(() {
                        //exception = e.toString();
                        exception = Auth().getExceptionText(e);
                      });
                    }
                  } //method
                },
                child: Text('Register'),
              ),
            ),
          ],
        ));
  }

  Widget _back(BuildContext context) {
    return ElevatedButton(
        child: Text('return to login?'),
        onPressed: () {
          Navigator.pop(
            context,
            MaterialPageRoute(
              builder: (context) {
                return LoginPage();
              },
            ),
          );
        });
  }
}

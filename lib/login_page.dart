import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_eureka_flutter/home_page.dart';
import 'package:project_eureka_flutter/sign_in.dart';
import 'package:project_eureka_flutter/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final RegExp _emailValid = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp _passwordValid =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

bool _success;
String _userEmail;

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;

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
              _forgotPassword(context),
              //_signUpButton(context),
              _signInButton(context),
            ],
          ),
        ),
      ),
    );
  }

  void signInGoogle(result) {
    signInWithGoogle().then((result) {
      if (result != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomePage();
            },
          ),
        );
      }
    });
  }

  void signIn(_formKey) {
    if (_formKey.currentState.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomePage();
          },
        ),
      );
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Widget _form(BuildContext context) {
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
                  return 'Invalid Input';
                }
                return null;
              },
              //controller: _emailController,
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
                } else if (_passwordValid.hasMatch(value)) {
                  return 'Missing something';
                }
                return null;
              },
              controller: _passwordController,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  signIn(_formKey);
                },
                child: Text('Submit'),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SignupPage();
                        },
                      ),
                    );
                  },
                  child: Text('signup'),
                )),
          ],
        ));
  }

  Widget _forgotPassword(BuildContext context) {
    return TextButton(onPressed: null, child: Text('forgot password?'));
  }

  Widget _signInButton(BuildContext context) {
    return FlatButton(
      color: Colors.red,
      onPressed: () {
        signInGoogle(context);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

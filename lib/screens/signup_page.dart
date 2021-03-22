import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:project_eureka_flutter/components/eureka_rounded_button.dart';
import 'package:project_eureka_flutter/screens/root_page.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';
import 'package:project_eureka_flutter/services/firebase_exception_handler.dart';

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
  bool _isHiddenPassword;

  final RegExp _emailValid = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  final RegExp _passwordValid =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  void initState() {
    _isHiddenPassword = true;
    super.initState();
  }

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
                return RootPage();
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
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 40.0),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: Color(0xF6F6F6F6),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey[200],
                  ),
                ),
                prefixIcon: Icon(Icons.email),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Email required.';
                } else if (!_emailValid.hasMatch(value)) {
                  return 'Please enter a valid email address.';
                }
                _userEmail = value.trim();
                return null;
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              obscureText: _isHiddenPassword,
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor: Color(0xF6F6F6F6),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey[200],
                  ),
                ),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isHiddenPassword = !_isHiddenPassword;
                    });
                  },
                  icon: Icon(
                    _isHiddenPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Password required.';
                } else if (!_passwordValid.hasMatch(value)) {
                  return 'Please enter a valid password.';
                }
                _password = value;
                return null;
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              obscureText: _isHiddenPassword,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                filled: true,
                fillColor: Color(0xF6F6F6F6),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey[200],
                  ),
                ),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isHiddenPassword = !_isHiddenPassword;
                    });
                  },
                  icon: Icon(
                    _isHiddenPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Password required.';
                } else if (_password != value) {
                  return 'Passwords do not match.';
                }
                _password = value;
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Container _signUpbutton() {
    return Container(
      child: EurekaRoundedButton(
        buttonText: 'Create Account',
        onPressed: () => _validateAndSubmit(),
      ),
    );
  }

  Row _backToSignIn(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Already have an account?",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          child: Text(
            "Sign In",
            style: TextStyle(
              color: Color(0xFF00ADB5),
            ),
          ),
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return RootPage();
                },
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 120,
            ),
            child: Column(
              children: <Widget>[
                Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _form(context),
                Visibility(
                  visible: exception == "" ? false : true,
                  child: Text(
                    exception,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                _backToSignIn(context),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _signUpbutton(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:project_eureka_flutter/components/eureka_rounded_button.dart';
import 'package:project_eureka_flutter/screens/profile_onboarding_screen.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';
import 'package:project_eureka_flutter/services/firebase_exception_handler.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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

  Future<void> _validateAndSubmit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    try {
      String newUser = await _emailAuth.signUp(_userEmail, _password);

      if (newUser != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileOnboarding(
              isProfile: false,
            ),
          ),
          (Route<void> route) => false,
        );
      }
    } catch (e) {
      setState(() {
        exception = _firebaseExceptionHandler.getExceptionText(e);
        print("exception" + exception);
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
            Visibility(
              visible: exception == "" ? false : true,
              child: Text(
                exception,
                style: TextStyle(color: Colors.red),
              ),
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
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters.';
                } else if (!_passwordValid.hasMatch(value)) {
                  return 'Must contain a number, special character and uppercase letter.';
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
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
              Colors.teal[300],
              Colors.teal[200],
              Colors.teal[100],
              Colors.teal[50],
            ],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
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
                  _backToSignIn(context),
                  SizedBox(height: 145.0),
                  _signUpbutton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

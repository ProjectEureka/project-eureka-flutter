import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_eureka_flutter/screens/home_screen.dart';
import 'package:project_eureka_flutter/screens/profile_onboarding_screen.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:project_eureka_flutter/services/firebase_exception_handler.dart';
import 'package:project_eureka_flutter/services/google_auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  EmailAuth _emailAuth = new EmailAuth();
  GoogleAuth _googleAuth = new GoogleAuth();
  FirebaseExceptionHandler _firebaseExceptionHandler =
      new FirebaseExceptionHandler();

  String email;
  String password;
  bool showSpinner = false;
  String exception = "";
  bool _isHiddenPassword;

  final RegExp _emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final RegExp _passwordValid =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  @override
  void initState() {
    _isHiddenPassword = true;
    super.initState();
  }

  void signInGoogle(result) async {
    try {
      _googleAuth.signInWithGoogle().then(
        (result) {
          if (result != null) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => result.additionalUserInfo.isNewUser
                    ? ProfileOnboarding(
                        isProfile: false,
                      )
                    : Home(),
              ),
              (Route<void> route) => false,
            );
          }
        },
      );
    } catch (e) {
      setState(() {
        exception = _firebaseExceptionHandler.getExceptionText(e);
      });
    }
  }

  Future<void> validateAndSubmitEmail() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    try {
      await _emailAuth.signIn(email, password);

      Navigator.pushNamedAndRemoveUntil(
          context, '/home', (Route<void> route) => false);
      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      setState(() {
        exception = _firebaseExceptionHandler.getExceptionText(e);
        showSpinner = false;
      });
    }
  }

  Widget _loginTextForm(context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                  showSpinner = false;
                  return 'Email required.';
                } else if (!_emailValid.hasMatch(value)) {
                  showSpinner = false;
                  return 'Invalid input.';
                }
                email = value.trim();
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
                  showSpinner = false;
                  return 'Password required.';
                } else if (!_passwordValid.hasMatch(value)) {
                  showSpinner = false;
                  return 'Invalid input.';
                }
                password = value;
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Center _orLoginWith() {
    return Center(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 1.0, 10.0, 1.0),
              child: Divider(color: Colors.black),
            ),
          ),
          Text(
            'OR SIGN IN WITH',
            style: TextStyle(color: Colors.black45),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 1.0, 10.0, 1.0),
              child: Divider(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Container _forgotPasswordButton(context) {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        child: Text(
          "Forgot password?",
          style: TextStyle(color: Colors.black54),
        ),
        onPressed: () async {
          Navigator.of(context).pushNamed('/forgotPassword');
        },
      ),
    );
  }

  Container _loginButton(context) {
    return Container(
      width: 350.0,
      height: 45.0,
      child: RaisedButton(
        onPressed: () async {
          setState(() {
            showSpinner = true;
          });
          validateAndSubmitEmail();
        },
        color: Color(0xFF00ADB5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Text(
            'Sign In',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }

  Row _signUpButton(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Don't have an account?",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          child: Text(
            "Sign up",
            style: TextStyle(
              color: Color(0xFF00ADB5),
            ),
          ),
          onPressed: () async {
            await Navigator.of(context).pushNamed('/signUp');
          },
        ),
      ],
    );
  }

  Container _googleSignInButton(context) {
    return Container(
      width: 350.0,
      height: 45.0,
      child: RaisedButton(
        onPressed: () => signInGoogle(context),
        color: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Text(
            'Google',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
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
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
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
                      'Sign In',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40.0),
                    _loginTextForm(context),
                    Visibility(
                      visible: exception == "" ? false : true,
                      child: Text(
                        exception,
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    _forgotPasswordButton(context),
                    SizedBox(height: 30.0),
                    _loginButton(context),
                    _signUpButton(context),
                    SizedBox(height: 20.0),
                    _orLoginWith(),
                    SizedBox(height: 10.0),
                    _googleSignInButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

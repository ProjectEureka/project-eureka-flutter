import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_eureka_flutter/screens/forgot_password.dart';
import 'package:project_eureka_flutter/screens/home_page.dart';
import 'package:project_eureka_flutter/screens/signup_page.dart';
import 'package:project_eureka_flutter/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:project_eureka_flutter/services/sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool showSpinner = false;
  String exception = "";
  final RegExp _emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final RegExp _passwordValid =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  String _userEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
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
              //_forgotPassword(context),
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
              return Home();
            },
          ),
        );
      }
    });
  }

  Future<String> signIn(_formKey) async {
    if (_formKey.currentState.validate()) {
      try {
        //UserCredential result = Auth().login(String email, String password);
        UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Home();
            },
          ),
        );
      } catch (e) {
        print(e);
        setState(() {
          //exception = e.toString();
          exception = Auth().getExceptionText(e);
          showSpinner = false;
        });
      }
      setState(() {
        showSpinner = false;
      });
    }
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
                  showSpinner = false;
                  return 'Email needed';
                } else if (!_emailValid.hasMatch(value)) {
                  showSpinner = false;
                  return 'Invalid Input';
                }
                email = value;
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
                } else if (_passwordValid.hasMatch(value)) {
                  return 'Invalid input';
                }
                password = value;
                return null;
              },
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
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
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ForgotPassword();
                        },
                      ),
                    );
                  },
                  child: Text('forgotpassword?'),
                )),
          ],
        ));
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

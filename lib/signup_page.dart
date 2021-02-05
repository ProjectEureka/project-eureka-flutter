import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_eureka_flutter/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_eureka_flutter/login_page.dart';

//final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//final TextEditingController _emailController = TextEditingController();
//final TextEditingController _passwordController = TextEditingController();
final FirebaseAuth _auth = FirebaseAuth.instance;
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//bool _success;
String _userEmail;
String _password;

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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
              _back(context),
              //_signUpButton(context),
              //_signInButton(context),
            ],
          ),
        ),
      ),
    );
  }
}

void signIn(_formKey) {}

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
                return 'Invalid Input';
              }
              _userEmail = value;
              print('username good');
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
                return 'something';
              }
              _password = value;
              print('pass good');
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
              } else if (_passwordValid.hasMatch(value)) {
                return 'Password does not match';
              }
              _password = value;
              print('Confirm pass good');
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
                    print('in try');
                    final newUser = await _auth.createUserWithEmailAndPassword(
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
                    print(e);
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

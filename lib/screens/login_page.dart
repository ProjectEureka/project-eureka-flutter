import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_eureka_flutter/services/sign_in.dart';
import 'package:project_eureka_flutter/screens/home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              //FlutterLogo(size: 150),
              //SizedBox(height: 50),
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

  FlatButton _signInButton(BuildContext context) {
    return FlatButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInGoogle(context);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

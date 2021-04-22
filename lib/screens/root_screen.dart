import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/screens/home_screen.dart';
import 'package:project_eureka_flutter/screens/signin_screen.dart';
import 'package:project_eureka_flutter/screens/onboarding_screen.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';
import 'package:project_eureka_flutter/services/shared_preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  SharedPreferences _prefs;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  Future<void> _initState() async {
    await Firebase.initializeApp();

    _prefs = await SharedPreferences.getInstance();

    /// checks if the app has seen the onboarding screen yet
    /// if '1', they already have => go to Home/LoginPage instead.
    if (SharedPreferencesHelper().getInitScreen(_prefs) == 1) {
      /// checks to see if the user is signed in
      /// if no user found => show Login, else show Home
      if (EmailAuth().getCurrentUser() != null) {
        pushAndRemoveUntil(Home());
      } else {
        pushAndRemoveUntil(SignIn());
      }
    } else {
      pushAndRemoveUntil(Onboarding());
    }
  }

  Future<dynamic> pushAndRemoveUntil(Widget route) {
    return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => route,
      ),
      (Route<void> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

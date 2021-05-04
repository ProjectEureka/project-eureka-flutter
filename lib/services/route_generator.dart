import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/screens/forgot_password.dart';
import 'package:project_eureka_flutter/screens/home_screen.dart';
import 'package:project_eureka_flutter/screens/more_details_page.dart';
import 'package:project_eureka_flutter/screens/new_question_screen.dart';
import 'package:project_eureka_flutter/screens/onboarding_screen.dart';
import 'package:project_eureka_flutter/screens/root_screen.dart';
import 'package:project_eureka_flutter/screens/signin_screen.dart';
import 'package:project_eureka_flutter/screens/signup_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return CupertinoPageRoute(
          builder: (_) => RootScreen(),
        );
      case '/signIn':
        return CupertinoPageRoute(
          builder: (_) => SignIn(),
        );
      case '/onboarding':
        return CupertinoPageRoute(
          builder: (_) => Onboarding(),
        );
      case '/signUp':
        return CupertinoPageRoute(
          builder: (_) => SignUp(),
        );
      case '/forgotPassword':
        return CupertinoPageRoute(
          builder: (_) => ForgotPassword(),
        );
      case '/home':
        return CupertinoPageRoute(
          builder: (_) => Home(),
        );
      case '/newQuestion':
        return CupertinoPageRoute(
          builder: (_) => NewQuestion(),
        );
      case '/moreDetails':
        return CupertinoPageRoute(
          builder: (_) => MoreDetails(),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}

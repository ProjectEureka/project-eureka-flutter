import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:project_eureka_flutter/services/shared_preferences_helper.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        title: 'Welcome!',
        body:
            'EureQa is a question and answer application for everyone.\n\nHave a question? Ask away.\nHave an answer? Help a peer out.',
        image: Image.asset(
          'assets/images/EureQaLogo.png',
          fit: BoxFit.fitWidth,
        ),
        decoration: getPageDecoration(),
      ),
      PageViewModel(
        image: Image.asset(
          'assets/images/categories.png',
          height: 200,
        ),
        title: "Multiple Categories",
        body:
            'EureQa allows users to get quick answers to questions of different categories.\n\nAcademic, Lifestyle, Household and Technology',
        decoration: getPageDecoration(),
      ),
      PageViewModel(
        title: 'Collaboration Platform',
        body:
            'EureQa provides you with every tool to conveniently collaborate on any problem. \n\n Choose from chat messaging or live video calls.',
        image: Image.asset(
          'assets/images/collaboration.png',
          fit: BoxFit.fitWidth,
        ),
        decoration: getPageDecoration(),
      ),
      PageViewModel(
        title: 'Privacy Matters',
        body:
            "All communication happens in the app, so there's no ndeed to worry about giving out your personal information to strangers.",
        image: Image.asset(
          'assets/images/privacy.png',
          fit: BoxFit.fitWidth,
        ),
        decoration: getPageDecoration(),
      ),
      PageViewModel(
        image: Image.asset(
          'assets/images/getStarted.png',
          fit: BoxFit.fitWidth,
        ),
        title: 'Get Started',
        body:
            'Asking and answering questions has never been so fast and easy. Join us!',
        decoration: getPageDecoration(),
      ),
    ];
  }

  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        bodyTextStyle: TextStyle(
          fontSize: 18,
        ),
        descriptionPadding: EdgeInsets.all(16).copyWith(bottom: 0),
        imagePadding: EdgeInsets.all(24),
        boxDecoration: BoxDecoration(
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
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        pages: getPages(),
        showNextButton: true,
        showSkipButton: true,
        skip: Text(
          'Skip',
          style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold),
        ),
        done: Text(
          'Got it',
          style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold),
        ),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          color: Colors.grey[350],
          activeColor: Colors.teal[400],
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        onDone: () {
          SharedPreferencesHelper().setInitScreen(1);
          Navigator.of(context).pushNamed('/');
        },
      ),
    );
  }
}

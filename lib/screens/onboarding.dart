import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:project_eureka_flutter/screens/root_page.dart';
import 'package:project_eureka_flutter/services/shared_preferences_helper.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  List<PageViewModel> getPages() {
    return [
      PageViewModel(
          image: Image.asset('assets/images/logo.png'),
          title: 'Welcome to Eureka!',
          body:
              'Eureka is a platform for peers to help each other by answering questions \n\n Everyone can help and even get paid for help!',
          decoration: const PageDecoration(
              //pageColor: Color(0xfffdfafc),
              )),
      //-----------------------------------------------------------Incentives
      PageViewModel(
          image: Image.asset('assets/images/money.gif'),
          title: 'Incentives',
          body:
              'Eureka allows posting questions as on any regular forum, BUT also gives you an option of posting questions with an incentive \n\n'
              'Need answer ASAP? \n\n Try adding incentive to your question \n Paid questions get answers a lot faster!',
          decoration: const PageDecoration(
              //pageColor: Color(0xffB9AEFB),
              )),
      //-----------------------------------------------------------Collaboration
      PageViewModel(
        image: Image.asset('assets/images/onboarding2.gif'),
        title: 'Rich collaboration platform',
        body:
            'Eureka provides you with every tool to conveniently collaborate on any problem \n\n Choose from Text chat, Video chat, or Live Video Call ',
        decoration: const PageDecoration(
            //pageColor: Color(0xfffdfafc),
            ),
      ),
      //-----------------------------------------------------------Privacy
      PageViewModel(
        image: Image.asset('assets/images/privacy.png'),
        title: 'Your Privacy Matters!',
        body:
            'All communication happens in the app, so you don`t have to worry about giving out your personal information to strangers',
        decoration: const PageDecoration(
            //pageColor: Color(0xfffdfafc),
            ),
      ),
      //-----------------------------------------------------------Categories
      PageViewModel(
        image: Image.asset('assets/images/onboarding1.gif'),
        title: "Multiple categories",
        body:
            'Eureka has several most popular categories for questions and answers \n\n Lifestyle  Education  Electronics  Household',
        decoration: const PageDecoration(
          pageColor: Color(0xfffdfafc),
        ),
      ),
      //-----------------------------------------------------------All set
      PageViewModel(
        image: Image.asset('assets/images/onboarding3.gif'),
        title: 'You are all set!',
        body:
            'Asking and answering questions has never been so easy and rewarding \n You are ready to join! \n\n If you still have questions, visit our FAQ section',
        decoration: const PageDecoration(
          pageColor: Color(0xff6DB8FF),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        pages: getPages(),
        showNextButton: true,
        showSkipButton: true,
        skip: Text('Skip'),
        done: Text('Got it'),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        onDone: () {
          SharedPreferencesHelper().setInitScreen(1);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => RootPage()));
        },
      ),
    );
  }
}

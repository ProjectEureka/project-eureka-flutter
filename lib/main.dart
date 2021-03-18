import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_eureka_flutter/screens/onboarding.dart';
import 'package:project_eureka_flutter/styles/styles.dart';

//first time login checker
int initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1); //after first launch set to 1
  print(
      'initScreen ${initScreen}'); // printout to see how many times app was launched
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Project Eureka';
    //final Color ourBlueBackground = Color(0xFF37474F);

    return MaterialApp(
      title: appTitle,
      theme: Styles.lightTheme,
      darkTheme: Styles.darkTheme,
      // check if it's the first launch of app
      initialRoute: initScreen == 0 || initScreen == null ? "first" : "/",
      routes: {
        '/': (context) => LoginPage(),
        "first": (context) => Onboarding(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

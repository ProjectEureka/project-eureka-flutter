import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/onboarding.dart';

//first time login checker
int initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ), // check if it's the first launch of app
      initialRoute: initScreen == 0 || initScreen == null ? "first" : "/",
      routes: {
        '/': (context) => placeholder(),
        "first": (context) => Onboarding(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

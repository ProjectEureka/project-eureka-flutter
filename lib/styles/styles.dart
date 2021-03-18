import 'package:flutter/material.dart';

class Styles {
  // For light theme
  static final Color eurekaBackgroundColor = Color(0xFF37474F);
  // For dark theme
  static final Color darkBackgroundColor = Color(0xFF256580);
  static final Color eurekaAppBarColor = Color(0xFF402580);

  Styles._();

  static final ThemeData darkTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: darkBackgroundColor,
    primaryColor: eurekaAppBarColor,
  );

  static final ThemeData lightTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: eurekaBackgroundColor,
  );
}

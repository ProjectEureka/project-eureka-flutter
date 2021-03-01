import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final _initScreen = 'initScreen';

  Future<bool> setInitScreen(int initScreen) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(_initScreen, initScreen);
  }

  int getInitScreen(SharedPreferences prefs) {
    return prefs.containsKey(_initScreen) ? prefs.getInt(_initScreen) : null;
  }

  Future<bool> getSettings(String setting) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(setting) ??
        false; // if setting doesn't exist yet, give false
  }

  Future<void> setSettings(String setting, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(setting, value);
  }
}

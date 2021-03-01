import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsGeneral extends StatefulWidget {
  @override
  _SettingsGeneral createState() => _SettingsGeneral();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SettingsGeneral extends State<SettingsGeneral> {
  // initialized three settings
  bool _darkMode = false;
  bool _emailNotification = false;
  bool _textNotification = false;

  Future<bool> _getBoolValuesSF(String setting) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(setting) ??
        false; // if setting doesn't exist yet, give false
  }

  void _switchSetting(String setting, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(setting, value);
  }

  // get initial values of the settings once coming to the settings page
  void _getValuesSettings() {
    _getBoolValuesSF('darkMode').then((data) {
      setState(() {
        _darkMode = data;
      });
    });
    _getBoolValuesSF('emailNotification').then((data) {
      setState(() {
        _emailNotification = data;
      });
    });
    _getBoolValuesSF('textNotification').then((data) {
      setState(() {
        _textNotification = data;
      });
    });
  }

  @override
  void initState() {
    _getValuesSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EurekaAppBar(
        title: 'General Settings',
        appBar: AppBar(),
      ),
      body: Column(
        children: [
          settingsList(
            "Dark Mode",
            _darkMode,
            (bool value) {
              setState(() {
                _switchSetting('darkMode', value);
                _darkMode = value;
                print("Dark mode: " + _darkMode.toString());
              });
            },
          ),
          settingsList(
            "Email Notification",
            _emailNotification,
            (bool value) {
              setState(() {
                _switchSetting('emailNotification', value);
                _emailNotification = value;
                print("Email notification: " + _emailNotification.toString());
              });
            },
          ),
          settingsList(
            "Text Notification",
            _textNotification,
            (bool value) {
              setState(() {
                _switchSetting('textNotification', value);
                _textNotification = value;
                print("Text notification: " + _textNotification.toString());
              });
            },
          ),
          ListTile(
            title: Row(children: [
              Text('About   ', style: TextStyle(fontSize: 18.0)),
              Icon(CupertinoIcons.info_circle)
            ]),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('About Eureka'),
                      content: Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vel massa sit amet justo porta porttitor. Donec hendrerit sollicitudin malesuada. Mauris porttitor, odio vitae mattis lobortis, est lorem scelerisque ante, a vestibulum neque elit nec turpis. Pellentesque pulvinar tempor commodo. Donec leo velit, pharetra non imperdiet quis, bibendum et metus. Ut vitae sem lectus. Quisque id viverra risus, eget fermentum neque. Maecenas at augue magna. Donec dapibus condimentum sem eu molestie. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Donec in iaculis magna, vitae pretium magna. Fusce rutrum, nibh fermentum feugiat pharetra.',
                        textAlign: TextAlign.center,
                      ),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Close')),
                      ],
                    );
                  });
            },
          )
        ],
      ),
    );
  }
}

// settings builder function
SwitchListTile settingsList(String settingName, bool switchValue, setState) {
  return SwitchListTile(
      title: Text(settingName, style: TextStyle(fontSize: 18.0)),
      value: switchValue,
      onChanged: setState);
}

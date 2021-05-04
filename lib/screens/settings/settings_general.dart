import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/services/shared_preferences_helper.dart';

class SettingsGeneral extends StatefulWidget {
  @override
  _SettingsGeneral createState() => _SettingsGeneral();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SettingsGeneral extends State<SettingsGeneral> {
  SharedPreferencesHelper sharedPreferencesHelper = SharedPreferencesHelper();

  @override
  void initState() {
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
                        'EureQa is an app where users can provide help or request help through a system of answers and questions. Users will be able to connect live with each other, through our chat and video call system.',
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

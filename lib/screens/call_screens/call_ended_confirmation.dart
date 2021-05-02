import 'package:flutter/material.dart';

class CallEnded extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: AlertDialog(
          content: Text(
            'Call ended',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.pop(context), child: Text('Close')),
          ],
        ));
  }
}

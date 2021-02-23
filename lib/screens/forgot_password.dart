import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';
import 'package:project_eureka_flutter/services/firebase_exception_handler.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotpasswordState createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<ForgotPassword> {
  EmailAuth _emailAuth = new EmailAuth();
  FirebaseExceptionHandler _firebaseExceptionHandler =
      new FirebaseExceptionHandler();

  String _email;
  String _exception = "";

  void submit() async {
    try {
      await _emailAuth.forgotPassword(_email);

      SnackBar(
        content: const Text('request sent'),
      );

      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _exception = _firebaseExceptionHandler.getExceptionText(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password')),
      body: Container(
        color: Colors.lightBlueAccent[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
              onChanged: (value) {
                setState(() {
                  _email = value.trim();
                });
              },
            ),
            Visibility(
              visible: _exception == "" ? false : true,
              child: Text(
                _exception,
                style: TextStyle(color: Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () => submit(),
                child: Text('Send Request'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

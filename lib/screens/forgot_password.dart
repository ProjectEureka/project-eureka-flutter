import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';
import 'package:project_eureka_flutter/services/firebase_exception_handler.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotpasswordState createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  EmailAuth _emailAuth = new EmailAuth();
  FirebaseExceptionHandler _firebaseExceptionHandler =
      new FirebaseExceptionHandler();

  String _email;
  String _exception = "";

  Future<void> _submit(context) async {
    _formKey.currentState.save();
    try {
      await _emailAuth.forgotPassword(_email);
      _showDialog(context);
    } catch (e) {
      setState(() {
        _exception = _firebaseExceptionHandler.getExceptionText(e);
      });
    }
  }

  Container _emailField() {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                "If you've lost your password or wish to reset it, enter your email address and we'll send you instructions to create a new password.",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xF6F6F6F6),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
                prefixIcon: Icon(Icons.email),
                labelText: 'Email',
              ),
              onSaved: (value) {
                setState(() {
                  _email = value.trim();
                });
              },
            ),
            SizedBox(height: 10.0),
            Visibility(
              visible: _exception == "" ? false : true,
              child: Text(
                _exception,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _sendRequestButton(context) {
    return Container(
      width: 370.0,
      height: 45.0,
      child: RaisedButton(
        color: Color(0xFF00ADB5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        onPressed: () => _submit(context),
        child: Text(
          'Reset My Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

  Future<dynamic> _showDialog(context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Request Sent"),
          content: Text(
              "Head over to your email and follow the instructions provided to reset your password."),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                "Done",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF00ADB5),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EurekaAppBar(
        title: "Reset Password",
        appBar: AppBar(),
      ),
      body: Column(
        children: <Widget>[
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              children: <Widget>[
                _emailField(),
                SizedBox(height: 260.0),
                _sendRequestButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

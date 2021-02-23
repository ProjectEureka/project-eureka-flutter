import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/eureka_rounded_button.dart';
import 'package:project_eureka_flutter/components/eureka_text_form_field.dart';

class AccountSettingsPassword extends StatelessWidget {
  static final RegExp _regExp = RegExp(
      "[0-9a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.'-]{6,}");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Password"),
        toolbarHeight: 100,
        backgroundColor: Color(0xFF37474F),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              EurekaTextFormField(
                  labelText: "Current password",
                  errValidatorMsg: "Password is needed.",
                  regExp: _regExp,
                  onSaved: null),
              EurekaTextFormField(
                  labelText: "New password",
                  errValidatorMsg: "Password is needed.",
                  regExp: _regExp,
                  onSaved: null),
              EurekaTextFormField(
                  labelText: "Confirm password",
                  errValidatorMsg: "Password does not match",
                  regExp: _regExp,
                  onSaved: null),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: EurekaRoundedButton(
          onPressed: () => {},
          buttonText: 'Done',
        ),
      ),
    );
  }
}

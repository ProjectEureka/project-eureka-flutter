import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/eureka_rounded_button.dart';
import 'package:project_eureka_flutter/components/eureka_text_form_field.dart';

class AccountSettingsEmail extends StatelessWidget {
  static final RegExp _regExp = RegExp(
      "[0-9a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.'-]{6,}");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Email"),
        toolbarHeight: 100,
        backgroundColor: Color(0xFF37474F),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Your current email is jane.cabanayan@gmail.com. What would you like to change it to?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                  )),
              EurekaTextFormField(
                  labelText: "Email",
                  errValidatorMsg: "Email is needed.",
                  regExp: _regExp,
                  onSaved: null)
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

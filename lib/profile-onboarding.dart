import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:project_eureka_flutter/blank_page.dart';

class ProfileOnboarding extends StatefulWidget {
  @override
  _ProfileOnboardingState createState() => _ProfileOnboardingState();
}

class _ProfileOnboardingState extends State<ProfileOnboarding> {
  bool _profilePage = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int _role = 0;
  String _firstName;
  String _lastName;
  String _city;
  String _birthDate;

  TextStyle appBarTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  Map<int, Widget> _children = {
    0: Container(
      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
      child: Text(
        'None',
        style: TextStyle(fontSize: 20.0),
      ),
    ),
    1: Container(
      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
      child: Text(
        'Student',
        style: TextStyle(fontSize: 20.0),
      ),
    ),
    2: Container(
      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
      child: Text(
        'Teacher',
        style: TextStyle(fontSize: 20.0),
      ),
    ),
  };

  Column segmentedControl() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
          child: Text('Do you have a preference?'),
        ),
        MaterialSegmentedControl(
          children: _children,
          selectionIndex: _role,
          borderColor: Colors.grey,
          selectedColor: Color(0xFF00ADB5),
          unselectedColor: Colors.white,
          borderRadius: 32.0,
          onSegmentChosen: (index) {
            setState(() {
              _role = index;
            });
          },
        ),
        SizedBox(height: 20.0),
      ],
    );
  }

  Column profileTextFormField(
    String labelText,
    TextInputAction textInputAction,
    String validatorMsg,
    Function onSaved,
  ) {
    return Column(
      children: <Widget>[
        TextFormField(
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.text,
          textInputAction: textInputAction,
          validator: (value) {
            if (value.isEmpty) {
              return validatorMsg;
            }
            return null;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: labelText,
          ),
          onSaved: onSaved,
        ),
        SizedBox(height: 20.0),
      ],
    );
  }

  DateTimePicker birthDateSelector() {
    return DateTimePicker(
      initialValue: '',
      firstDate: DateTime(1930),
      lastDate: DateTime(2030),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Birthday',
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Birth date is required.';
        }
        return null;
      },
      onSaved: (value) => _birthDate = value,
    );
  }

  Expanded submitButton() {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FlatButton(
          onPressed: () {
            _validateAndSubmit();
          },
          color: Color(0xFF00ADB5),
          minWidth: MediaQuery.of(context).size.width - 50.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Confirm',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _validateAndSubmit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    print('$_role, $_firstName, $_lastName, $_city, $_birthDate');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BlankPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: _profilePage
            ? Text("Edit Your Profile", style: appBarTextStyle)
            : Text("Create Your Profile", style: appBarTextStyle),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              segmentedControl(),
              profileTextFormField(
                'First Name',
                TextInputAction.next,
                'First name is required.',
                (value) => _firstName = value.trim(),
              ),
              profileTextFormField(
                'Last Name',
                TextInputAction.next,
                'Last name is required.',
                (value) => _lastName = value.trim(),
              ),
              profileTextFormField(
                'City',
                TextInputAction.done,
                'Your city is required.',
                (value) => _city = value.trim(),
              ),
              birthDateSelector(),
              submitButton(),
            ],
          ),
        ),
      ),
    );
  }
}

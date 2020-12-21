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
  static final RegExp _lettersRegExp = RegExp('[a-zA-Z]');

  int _role = 0;
  String _firstName;
  String _lastName;
  String _city;
  String _birthDate;

  TextStyle _appBarTextStyle = TextStyle(
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

  SizedBox _sizedBoxPadding() {
    return const SizedBox(
      height: 20.0,
    );
  }

  Column _segmentedControl() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
          child: Text(
            'Do you prefer to help people with their questions or ask questions?',
            textAlign: TextAlign.center,
          ),
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
        _sizedBoxPadding(),
      ],
    );
  }

  Column _profileTextFormField(
    String labelText,
    TextInputAction textInputAction,
    String validatorMsg,
    RegExp regExp,
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
            } else if (!regExp.hasMatch(value)) {
              return 'Invalid input.';
            }
            return null;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: labelText,
          ),
          onSaved: onSaved,
        ),
        _sizedBoxPadding(),
      ],
    );
  }

  DateTimePicker _birthDateSelector() {
    return DateTimePicker(
      initialValue: '',
      firstDate: DateTime(1930),
      lastDate: DateTime(2030),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Date of Birth',
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Date of birth is required.';
        }
        return null;
      },
      onSaved: (value) => _birthDate = value,
    );
  }

  Container _submitButton() {
    return Container(
      padding: EdgeInsets.all(20.0),
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
    );
  }

  SingleChildScrollView _scrollingForm() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _segmentedControl(),
          _profileTextFormField(
            'First Name',
            TextInputAction.next,
            'First name is required.',
            _lettersRegExp,
            (value) => _firstName = value.trim(),
          ),
          _profileTextFormField(
            'Last Name',
            TextInputAction.next,
            'Last name is required.',
            _lettersRegExp,
            (value) => _lastName = value.trim(),
          ),
          _profileTextFormField(
            'City',
            TextInputAction.done,
            'Your city is required.',
            _lettersRegExp,
            (value) => _city = value.trim(),
          ),
          _birthDateSelector(),
        ],
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
            ? Text("Edit Your Profile", style: _appBarTextStyle)
            : Text("Create Your Profile", style: _appBarTextStyle),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: _scrollingForm(),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: _submitButton(),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/components/eureka_text_form_field.dart';
import 'package:project_eureka_flutter/components/eureka_toggle_switch.dart';
import 'package:project_eureka_flutter/screens/home_page.dart';
import 'package:project_eureka_flutter/models/user_model.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';
import 'package:project_eureka_flutter/services/profile_onboarding_service.dart';

class ProfileOnboarding extends StatefulWidget {
  final bool isProfile;

  ProfileOnboarding({
    @required this.isProfile,
  });

  @override
  _ProfileOnboardingState createState() => _ProfileOnboardingState();
}

class _ProfileOnboardingState extends State<ProfileOnboarding> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static final RegExp _nameRegExp = RegExp(
      "[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.'-]");
  static final RegExp _monthRegExp = RegExp('(((0)[0-9])|((1)[0-2]))');
  static final RegExp _dayRegExp = RegExp('([0-2][0-9]|(3)[0-1])');
  static final RegExp _yearRegExp = RegExp('(19|20)[0-9][0-9]');

  int _role = 0;
  String _firstName;
  String _lastName;
  String _city;
  String _birthMonth;
  String _birthDay;
  String _birthYear;
  DateTime _birthDate;

  EurekaAppBar _profileOnboardingAppBar() {
    return EurekaAppBar(
      title: widget.isProfile ? 'Edit Your Profile' : 'Create Your Profile',
      appBar: AppBar(),
      actions: [
        widget.isProfile
            ? IconButton(
                icon: Icon(
                  Icons.cancel,
                  color: Color(0xFF00ADB5),
                ),
                onPressed: () => Navigator.pop(context))
            : Container(),
      ],
    );
  }

  Row _birthDateForms() {
    return Row(
      children: <Widget>[
        Expanded(
          child: EurekaTextFormField(
            labelText: 'Month (MM)',
            keyboardType: TextInputType.number,
            errValidatorMsg: 'Required',
            regExp: _monthRegExp,
            onSaved: (value) => _birthMonth = value.trim(),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: EurekaTextFormField(
            labelText: 'Day (DD)',
            keyboardType: TextInputType.number,
            errValidatorMsg: 'Required',
            regExp: _dayRegExp,
            onSaved: (value) => _birthDay = value.trim(),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: EurekaTextFormField(
            labelText: 'Year (YYYY)',
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            errValidatorMsg: 'Required',
            regExp: _yearRegExp,
            onSaved: (value) => _birthYear = value.trim(),
          ),
        ),
      ],
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
          Container(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
            child: Text(
              'Do you prefer to help people with their questions or ask questions?',
              textAlign: TextAlign.center,
            ),
          ),
          EurekaToggleSwitch(
            labels: ['None', 'Student', 'Teacher'],
            initialLabelIndex: _role,
            setState: (index) {
              setState(() {
                _role = index;
              });
            },
          ),
          EurekaTextFormField(
            labelText: 'First Name',
            errValidatorMsg: 'First name is required.',
            regExp: _nameRegExp,
            onSaved: (value) => _firstName = value.trim(),
          ),
          EurekaTextFormField(
            labelText: 'Last Name',
            errValidatorMsg: 'Last name is required.',
            regExp: _nameRegExp,
            onSaved: (value) => _lastName = value.trim(),
          ),
          EurekaTextFormField(
            labelText: 'City',
            errValidatorMsg: 'Your city is required.',
            regExp: _nameRegExp,
            onSaved: (value) => _city = value.trim(),
          ),
          _birthDateForms(),
        ],
      ),
    );
  }

  void _validateAndSubmit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    _birthDate = DateTime.parse(
        '$_birthYear-$_birthMonth-$_birthDay'); // we're not even using this
    User _firebaseUser = EmailAuth().getCurrentUser();
    ProfileOnboardingService _profileOnboardingService =
        new ProfileOnboardingService();

    /// Create the user object to be sent out.
    UserModel user = new UserModel(
      firstName: _firstName,
      lastName: _lastName,
      firebaseUuid: _firebaseUser.uid,
      email: _firebaseUser.email,
      city: _city,
      category: [], //we don't have form field for this
      pictureUrl: '',
      role: _role,
      ratings: [],
      averageRating: 0.0,
    );

    /// Using the profile onboarding serivce, send data to backend
    try {
      if (widget.isProfile) {
        // Using HTTP PUT to update instead
        // This currently doesn't work until we can get the current user_id
        await _profileOnboardingService.updateUser(user);

        Navigator.pop(context);
      } else {
        // Using HTTP POST to add new user
        await _profileOnboardingService.addUser(user);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
          (Route<void> route) => false,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _profileOnboardingAppBar(),
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

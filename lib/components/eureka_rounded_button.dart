import 'package:flutter/material.dart';

/// This is a custom made Rounded Button made specifically for Project
/// Eureka. Please use this Widget when implementing big buttons so
/// we can have a uniform design thoughout our app.
class EurekaRoundedButton extends StatefulWidget {
  final Function onPressed;
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final bool isTwoButtons;

  /// Users will need to pass in values for the onPressed interation and
  /// what the text for this button will be.
  EurekaRoundedButton(
      {@required this.onPressed,
      @required this.buttonText,
      this.buttonColor,
      this.textColor,
      this.isTwoButtons});

  @override
  _EurekaRoundedButtonState createState() => _EurekaRoundedButtonState();
}

/// When changing any of these values, it will change for any
/// EurekaRoundedButton that is used.
class _EurekaRoundedButtonState extends State<EurekaRoundedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.isTwoButtons == null
          ? EdgeInsets.all(20.0)
          : EdgeInsets.all(9.0),
      child: FlatButton(
        onPressed: widget.onPressed,
        disabledColor: Colors.grey[400],
        color:
            widget.buttonColor == null ? Color(0xFF00ADB5) : widget.buttonColor,
        minWidth: MediaQuery.of(context).size.width - 50.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Text(
            widget.buttonText,
            style: TextStyle(
              color: widget.textColor == null ? Colors.white : widget.textColor,
              fontSize: 25.0,
            ),
          ),
        ),
      ),
    );
  }
}

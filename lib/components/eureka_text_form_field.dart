import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// This is a custom made TextForm made specifically for Project
/// Eureka. Please use this Widget when using any text form fields.
class EurekaTextFormField extends StatefulWidget {
  final String labelText;
  final TextCapitalization textCapitalization;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int maxLines;
  final String errValidatorMsg;
  final RegExp regExp;
  final Function onSaved;

  /// labelText, errValidatorMsg, validator RegEx, and onSaved functions are
  /// all required. textCapitalization, keyboardType, textInputAction, and
  /// maxLines are all option and if they have no values passed in, they
  /// will use the default values found below.
  EurekaTextFormField({
    @required this.labelText,
    this.textCapitalization,
    this.keyboardType,
    this.textInputAction,
    this.maxLines,
    @required this.errValidatorMsg,
    @required this.regExp,
    @required this.onSaved,
  });

  @override
  _EurekaTextFormFieldState createState() => _EurekaTextFormFieldState();
}

/// This widget will always add spacing of 20.0 below the text form
class _EurekaTextFormFieldState extends State<EurekaTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          /// if param added, else default value
          textCapitalization: widget.textCapitalization == null
              ? TextCapitalization.sentences
              : widget.textCapitalization,
          keyboardType: widget.keyboardType == null
              ? TextInputType.text
              : widget.keyboardType,
          textInputAction: widget.textInputAction == null
              ? TextInputAction.next
              : widget.textInputAction,
          maxLines: widget.maxLines == null ? 1 : widget.maxLines,
          validator: (value) {
            if (value.isEmpty) {
              return widget.errValidatorMsg;
            } else if (!widget.regExp.hasMatch(value)) {
              return 'Invalid input.';
            }
            return null;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: widget.labelText,
          ),
          onSaved: widget.onSaved,
        ),
        SizedBox(
          height: 20.0,
        )
      ],
    );
  }
}

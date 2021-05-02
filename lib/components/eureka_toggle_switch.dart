import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class EurekaToggleSwitch extends StatefulWidget {
  final List<String> labels;
  final int initialLabelIndex;

  final ValueChanged<dynamic> setState;

  EurekaToggleSwitch({
    @required this.labels,
    @required this.initialLabelIndex,
    @required this.setState,
  });

  @override
  _EurekaToggleSwitchState createState() => _EurekaToggleSwitchState();
}

class _EurekaToggleSwitchState extends State<EurekaToggleSwitch> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToggleSwitch(
          minWidth: MediaQuery.of(context).size.width - 300.0,
          cornerRadius: 32.0,
          activeBgColor: Color(0xFF00ADB5),
          activeFgColor: Colors.white,
          inactiveBgColor: Colors.grey[300],
          inactiveFgColor: Colors.grey,
          labels: widget.labels,
          initialLabelIndex: widget.initialLabelIndex,
          onToggle: (index) {
            widget.setState(index);
          },
        ),
        const SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}

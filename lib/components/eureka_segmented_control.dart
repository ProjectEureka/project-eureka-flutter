import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

/// This is a custom made Segmented Control made specifically for Project
/// Eureka. Please use this Widget when implementing a segmented control of
/// some type to prevent us from repeating ourselves.
class EurekaSegmenetedControl extends StatefulWidget {
  final int segmentedControlCount;
  final List<String> segmentedControlLabels;
  final int segmentedControlValue;
  final ValueChanged<dynamic> setState;

  /// These values are required to call upon this Widget. Most are self
  /// explanatory. The setState might be a bit confusing. The setState is
  /// required to allow for any values that will be changed when using
  /// this Widget.
  EurekaSegmenetedControl({
    @required this.segmentedControlCount,
    @required this.segmentedControlLabels,
    @required this.segmentedControlValue,
    @required this.setState,
  });

  @override
  _EurekaSegmenetedControlState createState() =>
      _EurekaSegmenetedControlState();
}

class _EurekaSegmenetedControlState extends State<EurekaSegmenetedControl> {
  Map<int, Container> _children = new Map<int, Container>();

  @override
  void initState() {
    populateSegmenetedControlChildren(widget.segmentedControlCount);
    super.initState();
  }

  /// This will build the styling of each individual segmeneted control
  /// in the form of a container.
  Container buildSegmentedControlChildren(String containerLabel) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
      child: Text(
        containerLabel,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  /// This populate the number of segmented controls that the Widget will have.
  void populateSegmenetedControlChildren(int childrenCount) {
    for (int i = 0; i < childrenCount; i++) {
      _children[i] =
          buildSegmentedControlChildren(widget.segmentedControlLabels[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MaterialSegmentedControl(
          children: _children,
          selectionIndex: widget.segmentedControlValue,
          borderColor: Colors.grey,
          selectedColor: Color(0xFF00ADB5),
          unselectedColor: Colors.white,
          borderRadius: 32.0,
          onSegmentChosen: (index) {
            setState(() {
              widget.setState(index);
            });
          },
        ),
        const SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}

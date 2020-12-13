
import 'package:flutter/material.dart';

/// This is the stateful widget that the main application instantiates.
class CategoryFilter extends StatefulWidget {
  final _callback;

  CategoryFilter({@required void getCategoryCallback(String category)}) : _callback = getCategoryCallback;

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<CategoryFilter> {

  String dropdownValue = 'All Categories';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.menu),
      iconSize: 25,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        // Call function in Home class
        widget?._callback(newValue);
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>[
        'All Categories',
        'Technology',
        'Household',
        'Category 3',
        'Category 4',
        'Category 5'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,
              style: TextStyle(fontSize: 15.0, color: Colors.purple)),
        );
      }).toList(),
    );
  }
}

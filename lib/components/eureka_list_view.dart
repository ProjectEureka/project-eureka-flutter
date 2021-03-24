import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Function to return List of Questions and category filter. Called from 'body'.
class EurekaListView extends StatefulWidget {
  final List<dynamic> filteredQuestionsList;
  final int index;

  EurekaListView({
    @required this.filteredQuestionsList,
    @required this.index,
  });
  @override
  _EurekaListViewState createState() => _EurekaListViewState();
}

class _EurekaListViewState extends State<EurekaListView> {
  SizedBox _sizedBox() {
    return SizedBox(
      height: 5.0,
    );
  }

  Text _eurekaListViewTextStyle({
    @required String value,
    @required Color color,
    FontWeight fontWeight,
    double fontSize,
  }) {
    return Text(
      value,
      textAlign: TextAlign.left,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
        fontSize: fontSize == null ? 15.0 : fontSize,
      ),
    );
  }

  Column categoryRow(int index) {
    return Column(
      children: [
        _eurekaListViewTextStyle(
          value: widget.filteredQuestionsList[index].category,
          color: Colors.grey,
        ),
        _sizedBox(),
      ],
    );
  }

  Column timeAndIsActiveRow(int index) {
    // this is used to format data to return " X days/hours/minutes ago"
    final dateTime = DateTime.parse(widget.filteredQuestionsList[index].questionDate).subtract(new Duration(minutes: 1));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _eurekaListViewTextStyle(
                  value: "Asked:\t",
                  color: Colors.grey,
                ),
                _eurekaListViewTextStyle(
                  // timeago is used to format data to return " X days/hours/minutes ago"
                  value: timeago.format(dateTime),
                  color: Colors.black,
                ),
              ],
            ),
            _eurekaListViewTextStyle(
              value:
                  // status is a boolean
                  widget.filteredQuestionsList[index].status
                      ? "Active"
                      : "Closed",
              color: widget.filteredQuestionsList[index].status
                      ? Colors.blue
                      : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        _sizedBox(),
      ],
    );
  }

  Column titleRow(int index) {
    return Column(
      children: [
        _eurekaListViewTextStyle(
          value: widget.filteredQuestionsList[index].title,
          color: Colors.black,
          fontSize: 20.0,
        ),
        _sizedBox(),
      ],
    );
  }

  Text descriptionRow(int index) {
    return Text(
      widget.filteredQuestionsList[index].description,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 15.0,
        color: Colors.grey,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Row moreDetailsButtonRow(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Button to open Question page
        FlatButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () {
            // Question page redirection here
          },
          child: Text(
            "More Details",
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.purple,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Padding _buildIndividualList(int index) {
    return Padding(
      padding: const EdgeInsets.all(
        5.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  categoryRow(index),
                  timeAndIsActiveRow(index),
                  titleRow(index),
                  descriptionRow(index),
                  moreDetailsButtonRow(index),
                  Divider(
                    color: Colors.blue,
                    thickness: 3.0,
                    height: 0.0,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildIndividualList(widget.index);
  }
}

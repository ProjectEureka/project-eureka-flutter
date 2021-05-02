import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/screens/more_details_page.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfileAnswersView extends StatefulWidget {
  final List<dynamic> answersList;
  final int index;

  ProfileAnswersView({
    @required this.answersList,
    @required this.index,
  });

  @override
  _ProfileAnswersViewState createState() => _ProfileAnswersViewState();
}

class _ProfileAnswersViewState extends State<ProfileAnswersView> {
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

  Column timeAndIsActiveRow(int index) {
    // this is used to format data to return " X days/hours/minutes ago"
    final dateTime = DateTime.parse(widget.answersList[index].answerDate)
        .subtract(Duration(hours: -7));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _eurekaListViewTextStyle(
                  value: "Answered:\t",
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
              value: index == 1
                  ? "Best Answer"
                  : "", // for testing purposes it only shows one best answer
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        _sizedBox(),
      ],
    );
  }

  Text descriptionRow(int index) {
    return Text(
      widget.answersList[index].description,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 15.0,
        color: Colors.grey[600],
      ),
      maxLines: 4,
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MoreDetails(
                  questionId: widget.answersList[index].questionId,
                ),
              ),
            );
          },
          child: Text(
            "Question Details",
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
                  timeAndIsActiveRow(index),
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

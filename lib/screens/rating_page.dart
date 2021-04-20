import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:project_eureka_flutter/components/eureka_rounded_button.dart';
import 'package:project_eureka_flutter/models/rating_model.dart';
import 'package:project_eureka_flutter/screens/home_page.dart';
import 'package:project_eureka_flutter/services/close_question_service.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';
import 'package:project_eureka_flutter/services/rating_service.dart';

class RatingPage extends StatefulWidget {
  final String id;
  final double rating;
  final String questionId;
  final String answerId;

  RatingPage({this.id, this.rating, this.questionId, this.answerId});

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  double _rating;
  int _ratingBarMode = 1;
  IconData _selectedIcon;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff00adb5),
        body: Center(
          child: SingleChildScrollView(
              child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 40.0,
                ),
                Column(
                  children: [
                    _profilePicture('assets/images/batman.png'),
                    SizedBox(
                      height: 40.0,
                    ),
                    _heading('How was your session with', 24.0),
                    _heading('Tony N?', 24.0),
                    _ratingBar(_ratingBarMode),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                EurekaRoundedButton(
                  buttonText: _rating == null ? 'Skip' : 'Done!',
                  onPressed: () => _submit(),
                ),
              ],
            ),
          )),
        ));
  }

  //Rates the current user for now until the answer page is created
  Future<void> _submit() async {
    final response = await CloseQuestionService().closeQuestion(widget.questionId, widget.answerId);
    print("Status " + response.statusCode.toString() + ". Question closed successfully - " + widget.questionId.toString());
    RatingModel rating =
        new RatingModel(id: EmailAuth().getCurrentUser().uid, rating: _rating);
    try {
      await RatingService().updateRating(rating);
    } catch (e) {
      print(e);
    }
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return Home();
      },
    ));
  }

  void checkRating() {
    double checker = _rating;
    if (checker != null) {
      print(checker);
    } else {
      print('Rating is null: $checker');
    }
  }

  Center _profilePicture(String profileImage) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 55.0,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage(profileImage),
              ),
            ),
          ]),
    );
  }

  Widget _heading(String text, double fontSize) => Container(
        child: Column(
          children: [
            Text(
              text,
              style: TextStyle(
                color: Color(0xFF666666),
                fontWeight: FontWeight.w300,
                fontSize: 24.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      );

  Widget _ratingBar(int mode) {
    return RatingBar.builder(
      glow: false,
      initialRating: 0,
      minRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: true,
      unratedColor: Colors.amber.withAlpha(50),
      itemCount: 5,
      itemSize: 50.0,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        _selectedIcon ?? Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _rating = rating;
        });
      },
      updateOnDrag: true,
    );
  }
}

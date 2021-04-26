import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:project_eureka_flutter/components/eureka_rounded_button.dart';
import 'package:project_eureka_flutter/models/rating_model.dart';
import 'package:project_eureka_flutter/models/user_model.dart';
import 'package:project_eureka_flutter/services/close_question_service.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';
import 'package:project_eureka_flutter/services/rating_service.dart';

import 'home_screen.dart';

class Rating extends StatefulWidget {
  final UserModel userInfo;
  final String questionId;
  final String answerId;

  Rating({this.userInfo, this.questionId, this.answerId});

  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  double _rating;
  int _ratingBarMode = 1;
  IconData _selectedIcon;
  bool loading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff00adb5),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
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
                  Container(
                    alignment: Alignment(0.8, 0),
                    child: FlatButton(
                        onPressed: () async => {
                              await _closeQuestion(),
                              Navigator.of(context).pushNamed('/home')
                            },
                        child: Text('Skip', style: TextStyle(fontSize: 18))),
                  ),
                  Column(
                    children: [
                      _profilePicture(widget.userInfo.pictureUrl),
                      SizedBox(
                        height: 40.0,
                      ),
                      _heading('How was your session with', 24.0),
                      _heading(
                          widget.userInfo.firstName +
                              ' ' +
                              widget.userInfo.lastName,
                          24.0),
                      _ratingBar(_ratingBarMode),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  EurekaRoundedButton(
                    buttonText: 'Done!',
                    onPressed: () => _submit(),
                  ),
                ],
              ),
            )),
          ),
        ));
  }

  Future<void> _closeQuestion() async {
    final response = await CloseQuestionService()
        .closeQuestion(widget.questionId, widget.answerId);
    print("Status " +
        response.statusCode.toString() +
        ". Question closed successfully - " +
        widget.questionId.toString());
  }

  //Rates the current user for now until the answer page is created
  Future<void> _submit() async {
    await _closeQuestion();
    RatingModel rating =
        new RatingModel(id: widget.userInfo.id, rating: _rating);
    try {
      await RatingService().updateRating(rating);
    } catch (e) {
      print(e);
    }
    Navigator.of(context).pushNamed('/home');
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
              radius: 60.0,
              backgroundColor: Color(0xff00adb5),
              child: CircleAvatar(
                radius: 60.0,
                backgroundColor: Colors.transparent,
                backgroundImage: widget.userInfo.pictureUrl == ""
                    ? AssetImage('assets/images/profile_default_image.png')
                    : NetworkImage(widget.userInfo.pictureUrl),
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
      initialRating: 5,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      unratedColor: Colors.amber.withAlpha(120),
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

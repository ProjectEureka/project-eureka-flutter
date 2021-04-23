import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/components/eureka_image_viewer.dart';
import 'package:project_eureka_flutter/components/eureka_rounded_button.dart';
import 'package:project_eureka_flutter/models/answer_model.dart';
import 'package:project_eureka_flutter/models/question_model.dart';
import 'package:project_eureka_flutter/screens/home_page.dart';
import 'package:project_eureka_flutter/screens/rating_page.dart';
import 'package:project_eureka_flutter/screens/rating_screen.dart';

class NewFormConfirmation extends StatefulWidget {
  final bool isAnswer; // true: this for is for Answers
  final QuestionModel questionModel;
  final AnswerModel answerModel;

  NewFormConfirmation({
    this.questionModel,
    @required this.isAnswer,
    this.answerModel,
  });

  @override
  _NewFormConfirmationState createState() => _NewFormConfirmationState();
}

class _NewFormConfirmationState extends State<NewFormConfirmation> {
  Container _formConfirmationBody() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              widget.isAnswer ? "Answer Submitted" : "Question Submitted!",
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(
              height: 20.0,
            ),
            _formConfirmationContainer(),
          ],
        ),
      ),
    );
  }

  Text _formConfirmationTextStyling(String text, [bool bold]) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: bold == null ? null : FontWeight.bold,
      ),
    );
  }

  Expanded _formConfirmationContainer() {
    return Expanded(
      child: Container(
        alignment: Alignment.topLeft,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.isAnswer
                      ? Container()
                      : _formConfirmationTextStyling('Title:', true),
                  widget.isAnswer
                      ? Container()
                      : _formConfirmationTextStyling(
                          widget.questionModel.title),
                  _formConfirmationTextStyling(
                      widget.isAnswer ? 'Answer:' : 'Details:', true),
                  Container(
                    height: MediaQuery.of(context).size.height * .20,
                    child: SingleChildScrollView(
                      child: _formConfirmationTextStyling(
                        widget.isAnswer
                            ? widget.answerModel.description
                            : widget.questionModel.description,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * .15,
                child: ListView.builder(
                  itemCount: widget.isAnswer
                      ? widget.answerModel.mediaUrls.length
                      : widget.questionModel.mediaUrls.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(2.5, 0.0, 2.5, 0.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EurekaImageViewer(
                              imagePath: widget.isAnswer
                                  ? widget.answerModel.mediaUrls[index]
                                  : widget.questionModel.mediaUrls[index],
                              isUrl: true,
                            ),
                          ),
                        ),
                        child: Image.network(
                          widget.isAnswer
                              ? widget.answerModel.mediaUrls[index]
                              : widget.questionModel.mediaUrls[index],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EurekaAppBar(
        title: widget.isAnswer ? 'Answer' : 'Question',
        appBar: AppBar(),
      ),
      body: _formConfirmationBody(),
      bottomNavigationBar: EurekaRoundedButton(
        buttonText: "Return to Home Page",
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(), // Return to Home() when Ratings done
            builder: (context) =>
                Rating(), // Return to Home() when Ratings done
          ),
        ),
      ),
    );
  }
}

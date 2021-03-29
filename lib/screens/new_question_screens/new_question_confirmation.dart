import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/components/eureka_image_viewer.dart';
import 'package:project_eureka_flutter/components/eureka_rounded_button.dart';
import 'package:project_eureka_flutter/models/question_model.dart';
import 'package:project_eureka_flutter/screens/rating_page.dart';

class NewQuestionConfirmation extends StatefulWidget {
  final QuestionModel questionModel;

  NewQuestionConfirmation({
    @required this.questionModel,
  });

  @override
  _NewQuestionConfirmationState createState() =>
      _NewQuestionConfirmationState();
}

class _NewQuestionConfirmationState extends State<NewQuestionConfirmation> {
  Container _questionConfirmationBody() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              "Question Submitted!",
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(
              height: 20.0,
            ),
            _questionConfirmationContainer(),
          ],
        ),
      ),
    );
  }

  Text _questionCornfirmationTextStyling(String text, [bool bold]) {
    return Text(
      text,
      //maxLines: 4,
      style: TextStyle(
          fontSize: 18.0, fontWeight: bold == null ? null : FontWeight.bold),
    );
  }

  Expanded _questionConfirmationContainer() {
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
                  _questionCornfirmationTextStyling('Title:', true),
                  _questionCornfirmationTextStyling(widget.questionModel.title),
                  _questionCornfirmationTextStyling('Details:', true),
                  Container(
                    height: MediaQuery.of(context).size.height * .20,
                    child: SingleChildScrollView(
                      child: _questionCornfirmationTextStyling(
                          widget.questionModel.description),
                    ),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * .15,
                child: ListView.builder(
                  itemCount: widget.questionModel.mediaUrls.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(2.5, 0.0, 2.5, 0.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EurekaImageViewer(
                              imagePath: widget.questionModel.mediaUrls[index],
                              isUrl: true,
                            ),
                          ),
                        ),
                        child: Image.network(
                          widget.questionModel.mediaUrls[index],
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
        title: 'New Question',
        appBar: AppBar(),
      ),
      body: _questionConfirmationBody(),
      bottomNavigationBar: EurekaRoundedButton(
        buttonText: "Return to Home Page",
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RatingPage(), // Return to Home() when done
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/screens/new_question_form.dart';

class NewQuestionScreen extends StatelessWidget {
  Padding categoryButtonRow(
    BuildContext context,
    List<Widget> buttons,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: buttons,
      ),
    );
  }

  Expanded categoryButton(
    BuildContext context,
    String imageLink,
    String categoryName,
  ) {
    return Expanded(
      child: FlatButton(
        child: Column(
          children: [
            Image.network(imageLink),
            SizedBox(
              height: 12.0,
            ),
            Text(categoryName),
          ],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewQuestionForm(categoryName),
            ),
          );
        },
      ),
    );
  }

  Column categorySelector(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Choose Category",
                style: TextStyle(fontSize: 28.0),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        categoryButtonRow(
          context,
          <Widget>[
            categoryButton(
              context,
              'https://picsum.photos/250?image=9',
              "Lifestyle",
            ),
            categoryButton(
              context,
              'https://picsum.photos/250?image=9',
              "Adademic",
            )
          ],
        ),
        categoryButtonRow(
          context,
          <Widget>[
            categoryButton(
              context,
              'https://picsum.photos/250?image=9',
              "Household",
            ),
            categoryButton(
              context,
              'https://picsum.photos/250?image=9',
              "Technology",
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Question"),
      ),
      body: categorySelector(context),
    );
  }
}

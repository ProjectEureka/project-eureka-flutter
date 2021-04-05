import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/components/side_menu.dart';
import 'package:project_eureka_flutter/screens/new_form_screens/new_form.dart';

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
    String imageName,
    String categoryName,
  ) {
    return Expanded(
      child: FlatButton(
        child: Column(
          children: [
            Image.asset('assets/images/$imageName'),
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
              builder: (context) => NewForm(
                categoryName: categoryName,
                isAnswer: false,
              ),
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
              'lifestyle.png',
              "Lifestyle",
            ),
            categoryButton(
              context,
              'academic.png',
              "Academic",
            )
          ],
        ),
        categoryButtonRow(
          context,
          <Widget>[
            categoryButton(
              context,
              'household.png',
              "Household",
            ),
            categoryButton(
              context,
              'technology.png',
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
      drawer: SideMenu(),
      appBar: EurekaAppBar(
        title: 'New Question',
        appBar: AppBar(),
      ),
      body: categorySelector(context),
    );
  }
}

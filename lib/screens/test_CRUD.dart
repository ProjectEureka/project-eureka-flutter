import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/components/side_menu.dart';
import 'package:http/http.dart' as http;

class TestSpring extends StatefulWidget {
  TestSpring({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<TestSpring> {

  Future<Question> futureLastQuestion;
  Future<Question> futurePostQuestion;

  final TextEditingController _titlePOSTandPUT = TextEditingController();
  final TextEditingController _descriptionPOSTandPUT = TextEditingController();
  final TextEditingController _categoryPOSTandPUT = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureLastQuestion = fetchQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: EurekaAppBar(
        title: 'Test REST API',
        appBar: AppBar(),
      ),
      body: Center(
        child: FutureBuilder<Question>(
          future: futureLastQuestion,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(children: [

                // GET (returns last question)
                Text("MOST RECENT QUESTION", style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),),
                Text("ID:   " + snapshot.data.id),
                Text("TITLE:   " + snapshot.data.title),
                Text("DESCRIPTION:   " + snapshot.data.description),
                Text("CATEGORY:   " + snapshot.data.category),
                Text("DATE:   " + snapshot.data.questionDate),
                Text("USER ID:   " + snapshot.data.userId),

                // POST, PUT, and DELETE
                Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextField(
                          controller: _titlePOSTandPUT,
                          decoration: InputDecoration(hintText: 'Enter Title'),
                        ),
                        TextField(
                          controller: _descriptionPOSTandPUT,
                          decoration: InputDecoration(hintText: 'Enter Description'),
                        ),
                        TextField(
                          controller: _categoryPOSTandPUT,
                          decoration: InputDecoration(hintText: 'Enter Category'),
                        ),
                        ElevatedButton(
                          child: Text('POST question'),
                          onPressed: () {
                            setState(() {
                              futureLastQuestion = postQuestion(_titlePOSTandPUT.text, _descriptionPOSTandPUT.text, _categoryPOSTandPUT.text);
                            });
                          },
                        ),

                        // PUT
                        ElevatedButton(
                          child: Text('PUT the last question'),
                          onPressed: () {
                            setState(() {
                              futureLastQuestion = putQuestion(snapshot.data.id, _titlePOSTandPUT.text, _descriptionPOSTandPUT.text, _categoryPOSTandPUT.text);
                            });
                          },
                        ),

                        // DELETE button
                        ElevatedButton(
                          child: Text('DELETE the last question'),
                          onPressed: () {
                            // snapshot.data.id is coming from the GET operation
                            deleteQuestion(snapshot.data.id);
                            print("Question deleted");
                            // seems like sometimes there might a delay, so it won't update the last question right away and you have to click delete twice
                            // this delay fixed it
                            Future.delayed(const Duration(milliseconds: 200), ()
                            {
                              setState(() {
                                futureLastQuestion = fetchQuestion();
                              });
                            });
                          },
                        ),
                      ],
                    )
                ),
              ]);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

// GET
Future<Question> fetchQuestion() async {
  final response = await http.get(Uri.http('AWS_IP_ADDRESS', '/v1/questions'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final body = json.decode(response.body);
    print("Question loaded");
    print(body[body.length-1]);
    return Question.fromJson(body[body.length-1]);
  } else {
    throw Exception('Failed to load question');
  }
}

// POST
Future<Question> postQuestion(String title, String description, String category) async {
  final response = await http.post(Uri.http('AWS_IP_ADDRESS', '/v1/questions'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    // at this point only title, description and category are not default values
    body: jsonEncode(<String, dynamic>{
      'title': title,
      'questionDate': "2012-04-23T18:25:43.511+00:00",
      'description': description,
      'category': category,
      'mediaUrls': ['media1.jpg', 'media2.jpg'],
      'status': 1,
      'visible': 1,
      'userId': "604597560441df1e551d9605",
    }),
  );

  if (response.statusCode == 201) {
    print("Question Posted");
    return Question.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

// PUT
Future<Question> putQuestion(String questionId, String title, String description, String category) async {
  final response = await http.put(Uri.http('AWS_IP_ADDRESS', '/v1/questions/' + questionId),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    // at this point only title, description and category are not default values
    body: jsonEncode(<String, dynamic>{
      'title': title,
      'questionDate': "2012-04-23T18:25:43.511+00:00",
      'description': description,
      'category': category,
      'mediaUrls': ['media1.jpg', 'media2.jpg'],
      'status': 1,
      'visible': 1,
      'userId': "604597560441df1e551d9605",
    }),
  );

  if (response.statusCode == 201) {
    print("Question Changed");
    return Question.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

// DELETE
void deleteQuestion(String questionId) async {
  final response = await http.delete(Uri.http('AWS_IP_ADDRESS', '/v1/questions/' + questionId));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print("Question Deleted");
  } else {
    throw Exception('Failed to load question');
  }
}

class Question {
  final String id;
  final String title;
  final String questionDate;
  final String description;
  final String category;
  // for Lists (both for list of string and list of integers), use List<dynamic>, e
  final List<dynamic> mediaUrls;
  final bool status;
  final bool visible;
  final String userId;

  Question(
      {this.id,
        this.title,
        this.questionDate,
        this.description,
        this.category,
        this.mediaUrls,
        this.status,
        this.visible,
        this.userId});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      title: json['title'],
      questionDate: json['questionDate'],
      description: json['description'],
      category: json['category'],
      mediaUrls: json['mediaUrls'],
      status: json['status'],
      visible: json['visible'],
      userId: json['userId'],
    );
  }
}

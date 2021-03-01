import 'package:flutter/material.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/components/side_menu.dart';
import 'package:project_eureka_flutter/models/question_model.dart';
import 'package:project_eureka_flutter/services/category_filter.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Questions data. Unfiltered list of questions
  List data = [];
  // Will filter the list of questions
  List questionsListFiltered = [];
  // These lists will help to filter questions by both search key and category simultaneously
  // Might be inefficient to use that many lists around, thus, this might change in the future versions to something more dynamic and efficient
  List questionsListFilteredCategory = [];
  List questionsListFilteredSearch = [];
  // isSearching keep track of whether search bar is activated or not. Search bar will appear if user clicked a search icon.
  bool isSearching = false;
  // Keeps track of the last chosen category. By default is All Categories.
  String selectedCategory = "All Categories";

  // Called from widget (class) category filter
  void getCategory(value) {
    setState(() {
      filterQuestionsCategory(value);
    });
  }

  // Here Eureka will get data from the database.
  // At this point it contains just dummy lists of questions for test purposes
  Future<List> getQuestions() async {
    // List of 2 dummy questions
    List list1 = List.generate(2, (index) => "Message")
        .map((val) => QuestionModel(
              category: "Technology",
              date: DateTime.now(),
              status: 0,
              visible: 1,
              title: "Linux installation issue - usb not found",
              description:
                  "Hello. I have a Smartbuy 16Gb USB 2.0 flash drive (with new memory controller) that is not recognized in any Linux system, but on Windows it recognized and worked fine. When I connect it to the PC on Linux system, nothing happens",
            ))
        .toList();

    // List of another 2 dummy questions (different)
    List list2 = List.generate(2, (index) => "Message")
        .map((val) => QuestionModel(
              category: "Household",
              date: DateTime.now(),
              status: 1,
              visible: 1,
              title: "Windows Issue",
              description: "Hello",
            ))
        .toList();

    // List of another 2 dummy questions (different)
    List list3 = List.generate(2, (index) => "Message")
        .map((val) => QuestionModel(
              category: "Technology",
              date: DateTime.now(),
              status: 0,
              visible: 1,
              title: "iPhone not working",
              description: "iphone stopped working",
            ))
        .toList();

    // Combined 6 dummy questions together
    List list2list3 = new List.from(list2)..addAll(list3);
    data = new List.from(list1)..addAll(list2list3);
    return data;
  }

  void initGetQuestions() {
    getQuestions().then((data) {
      setState(() {
        questionsListFiltered =
            questionsListFilteredSearch = questionsListFilteredCategory = data;
      });
    });
  }

  void searchingFalse() {
    // Button to drop search bar. Will keep list filtered if category filter is applied
    setState(() {
      this.isSearching = false;
      questionsListFilteredSearch =
          data; // search list is now the same as the original
      filterQuestionsCategory(
          selectedCategory); // if "All Categories", then it page is completely unfiltered
    });
  }

  void searchingTrue() {
    setState(() {
      this.isSearching = true;
    });
  }

  // Get data from the database to the list. Questions are shown on home page is always questionsListFiltered,
  // which at this point is a copy of a `data`, as no filters have been applied yet
  @override
  void initState() {
    initGetQuestions();
    super.initState();
  }

  // Called by search bar. Returns filtered list
  // At this point it can only search for a single keyword in question's Title
  // In case if category filter is applied to the list of questions, search filter is applied to `questionsListFilteredCategory`,
  //    which might or might not have filter applied
  void filterQuestionsSearch(value) {
    setState(() {
      questionsListFiltered = questionsListFilteredSearch =
          questionsListFilteredCategory
              .where((question) =>
                  question.title.toLowerCase().contains(value.toLowerCase())
                      ? true
                      : false)
              .toList();
    });
  }

  // Category filter.
  // In case if search is applied to the list of questions, category filter is applied to `questionsListFilteredSearch`,
  //    which might or might not have filter applied
  void filterQuestionsCategory(value) {
    selectedCategory = value;
    if (value == "All Categories") {
      questionsListFiltered =
          questionsListFilteredCategory = questionsListFilteredSearch;
    } else {
      setState(() {
        questionsListFiltered = questionsListFilteredCategory =
            questionsListFilteredSearch
                .where((question) => question.category
                        .toLowerCase()
                        .contains(value.toLowerCase())
                    ? true
                    : false)
                .toList();
      });
    }
  }

  Column questionsList() {
    return Column(
      children: [
        // List of Questions
        Expanded(
            // Show loading circle if results are taking time
            // Show "No results" if input text doesn't match with question title (later will be added to description too)
            child: _buildList(
                questionsListFiltered, filterQuestionsCategory, getCategory)),

        RawMaterialButton(
          onPressed: () {},
          fillColor: Colors.blueGrey[800],
          splashColor: Colors.grey,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: SizedBox(
              width: 200.0,
              child: Text(
                "Create New Question",
                maxLines: 1,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  AppBar homeAppBar() {
    return AppBar(
      // Title "Eureka" is changed to a search bar after search icon is clicked
      title: !isSearching
          ? Text('Eureka!')
          : TextField(
              onChanged: (value) {
                // Call function to apply search filter
                filterQuestionsSearch(value);
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  hintText: "Search Question",
                  hintStyle: TextStyle(color: Colors.white)),
            ),
      centerTitle: true,
      //toolbarHeight: 100,

      // Search icon is changed to search bar
      actions: <Widget>[
        isSearching
            ? IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  searchingFalse();
                },
              )
            : IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  searchingTrue();
                },
              ),

        // Chat button
        FlatButton(
          textColor: Colors.white,
          onPressed: () {}, // redirect to Chat page
          child: Icon(Icons.chat_sharp, color: Colors.cyan),
          shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
        ),
      ],
      backgroundColor: Colors.blueGrey[800],
    );
  }

  // *** WIDGET BUILD ***
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding:
            false, // fixed: "Create New Question" button was moving up while in keyboard mode
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0), // here the desired height
            // Call function homeAppBar
            child: homeAppBar()),

        // List of questions and a category filter
        // Call function questionsList
        drawer: SideMenu(),
        body: questionsList());
  }
}

// Function to return List of Questions and category filter. Called from 'body'.
ListView _buildList(
    questionsListFiltered, filterQuestionsCategory, getCategory) {
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  // Used to avoid some repetitive code
  Text questionTextStyle(
      String string, double fontSize, Color color, FontWeight FontWeight) {
    return Text(
      string,
      textAlign: TextAlign.left,
      style:
          TextStyle(fontSize: fontSize, color: color, fontWeight: FontWeight),
    );
  }

  return ListView.builder(
      itemCount: questionsListFiltered.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          // category filter are above the first row. If there is no questions to show, it will still be there.
          return Column(
            children: <Widget>[
              // Categories filter
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: CategoryFilter(getCategoryCallback: getCategory))
              ]),
              if (questionsListFiltered.length == 0)
                Center(child: Text("No results"))
            ],
          );
        }
        index -= 1;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      questionTextStyle(questionsListFiltered[index].category,
                          15.0, Colors.grey, FontWeight.normal),
                      SizedBox(height: 5),
                      Row(children: [
                        questionTextStyle(
                            "Asked:  ", 15.0, Colors.grey, FontWeight.normal),
                        questionTextStyle(
                            dateFormat
                                .format(questionsListFiltered[index].date)
                                .toString(),
                            15.0,
                            Colors.black,
                            FontWeight.normal),
                        questionTextStyle(
                            questionsListFiltered[index].status.toString() ==
                                    '1'
                                ? "       Active"
                                : "",
                            15.0,
                            Colors.blue,
                            FontWeight.bold),
                      ]),
                      SizedBox(height: 5),
                      questionTextStyle(questionsListFiltered[index].title,
                          20.0, Colors.black, FontWeight.normal),
                      SizedBox(height: 5),
                      Text(
                        questionsListFiltered[index].description,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 15.0, color: Colors.grey),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        // Button to open Question page
                        FlatButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onPressed: () {
                            // Question page redirection here
                          },
                          child: Text("More Details",
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.purple),
                              textAlign: TextAlign.right),
                        ),
                      ]),
                      Divider(color: Colors.blue, thickness: 3, height: 0)
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      });
}

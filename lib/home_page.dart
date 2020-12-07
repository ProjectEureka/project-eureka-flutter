import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'question_model.dart';
import 'category_filter.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final SearchBarController<QuestionModel> _searchBarController =
      SearchBarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140.0), // here the desired height
        child: AppBar(
          leading: FlatButton(
            textColor: Colors.white,
            onPressed: () {}, // open side menu
            child: Icon(Icons.menu, color: Colors.cyan),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
          title: Text(
            'Eureka!',
            style: TextStyle(
              fontSize: 40.0,
            ),
          ),
          centerTitle: true,
          actions: [
            FlatButton(
              textColor: Colors.white,
              onPressed: () {}, // redirect to Chat page
              child: Icon(Icons.chat_sharp, color: Colors.cyan),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
          backgroundColor: Colors.blueGrey[800],
        ),
      ),
      body: Column(
        children: [
          // Search bar
          // Category filter
          // List of Questions
          Expanded(child: _buildList()),

          // "Create New Question" button
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
      ),
    );
  }
}

ListView _buildList() {
  // search bar
  final SearchBarController<QuestionModel> _searchBarController =
      SearchBarController();

  List list = List.generate(10, (index) => "Message")
      .map((val) => QuestionModel(
            category: "Technology",
            time: "2 hours ago",
            status: "Active",
            title: "Linux installation issue - usb not found",
            description:
                "Hello. I have a Smartbuy 16Gb USB 2.0 flash drive (with new memory controller) that is not recognized in any Linux system, but on Windows it recognized and worked fine. When I connect it to the PC on Linux system, nothing happens",
          ))
      .toList();

  return ListView.builder(
      itemCount: list.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          // search bar and category filter are above the first row
          return Column(
            children: <Widget>[
              // Search bar
              Container(
                height: 80.0,
                child: SearchBar<QuestionModel>(
                  searchBarPadding: EdgeInsets.symmetric(horizontal: 70),
                  //onSearch: _getAllQuestions,    // search action
                  searchBarController: _searchBarController,
                ),
              ),

              // Categories filter
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: CategoryFilter(),
                )
              ]),
            ],
          );
        }
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
                      Text(
                        list[index - 1].category,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 15.0),
                      ),
                      SizedBox(height: 5),
                      Row(children: [
                        Text(
                          "Asked:  ",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 15.0, color: Colors.grey),
                        ),
                        Text(
                          list[index - 1].time,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 15.0, color: Colors.black),
                        ),
                        Text(
                          "        " + list[index - 1].status,
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                      SizedBox(height: 5),
                      Text(
                        list[index - 1].title,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 20.0, color: Colors.black),
                      ),
                      SizedBox(height: 5),
                      Text(
                        list[index - 1].description,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 15.0, color: Colors.grey),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        FlatButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onPressed: () {},
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

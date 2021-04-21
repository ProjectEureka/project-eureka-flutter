import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';
import 'package:project_eureka_flutter/screens/chat_screens/chat_screen.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser = EmailAuth().getCurrentUser();

class ChatScreenConversations extends StatefulWidget {
  @override
  _ChatScreenConversations createState() => _ChatScreenConversations();
}

class _ChatScreenConversations extends State<ChatScreenConversations> {
  final _auth = FirebaseAuth.instance;

  final _firestore = FirebaseFirestore.instance;
  _ChatScreenConversations();

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: EurekaAppBar(
          title: 'Chat',
          appBar: AppBar(),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[ConversationsStream()],
          ),
        ));
  }
}

class ConversationsStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        //uses async snapshot
        if (!snapshot.hasData) {
          return Center(
            child: Text("Start New Chat from a Question"),
          );
        }
        final conversations = snapshot.data.docs;
        List<ConversationBubble> conversationBubbles = [];
        for (var userChat in conversations) {
          final conversationText = userChat.data()['text'];
          final conversationStarter = userChat.data()['chatSender'];
          final conversationUserID = userChat.data()['chatIDUser'];
          final recipeintID = userChat.data()['recipientId'];
          final recipientName = userChat.data()['recipient'];
          final questionTitle = userChat.data()['questionTitle'];
          final conversationBubble = ConversationBubble(
              questionTitle: questionTitle,
              recipient: recipeintID == loggedInUser.uid
                  ? conversationStarter
                  : recipientName,
              recipientId: recipeintID == loggedInUser.uid
                  ? conversationUserID
                  : recipeintID,
              text: conversationText);
          if (conversationUserID == loggedInUser.uid ||
              recipeintID == loggedInUser.uid) {
            conversationBubbles.add(conversationBubble);
          }
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: conversationBubbles,
          ),
        );
      },
    );
  }
}

class ConversationBubble extends StatelessWidget {
  ConversationBubble(
      {this.recipient,
      this.text,
      this.recipientId,
      this.photoUrl,
      this.questionTitle});
  final String recipient;
  final String text;
  final String recipientId;
  final String photoUrl;
  final String questionTitle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Colors.cyan,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
        child: FlatButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(fromId: recipientId, recipient: recipient)));
          },
          child: Row(
            children: <Widget>[
              Material(
                child: Icon(
                  Icons.account_circle,
                  size: 50.0,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                          questionTitle, //Qusetion Title from backend should go here
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                    ),
                    Container(
                      child: Text(recipient,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

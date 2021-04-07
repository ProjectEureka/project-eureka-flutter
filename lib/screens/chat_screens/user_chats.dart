import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';

import 'chat_sceen.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser = EmailAuth().getCurrentUser();
String toId = "hJGcQsILP7XQDSvWY2Qx2k3MD0V2";

class ChatScreenConversations extends StatefulWidget {
  final String fromId;
  ChatScreenConversations(this.fromId);
  @override
  _ChatScreenConversations createState() => _ChatScreenConversations(fromId);
}

class _ChatScreenConversations extends State<ChatScreenConversations> {
  final _auth = FirebaseAuth.instance;
  String fromId;
  final _firestore = FirebaseFirestore.instance;
  _ChatScreenConversations(this.fromId);

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
            children: <Widget>[
              ConversationsStream(
                fromId: fromId,
              )
            ],
          ),
        ));
  }
}

class ConversationsStream extends StatelessWidget {
  //final String groupChatId;
  final String fromId;
  ConversationsStream({this.fromId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        //uses async snapshot
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final conversations = snapshot.data.docs;
        List<ConversationBubble> conversationBubbles = [];
        for (var userChat in conversations) {
          final conversationText = userChat.data()['text'];
          final conversationUserID = userChat.data()['chatIDUser'];
          final recipeintID = userChat.data()['recipientId'];
          final recipientName = userChat.data()['recipient'];
          //print(loggedInUser.email);
          print("name: ");
          print(recipientName);
          print(conversationUserID);

          final conversationBubble = ConversationBubble(
              recipient: recipientName,
              recipientId: recipeintID,
              text: conversationText);
          if (conversationUserID == loggedInUser.uid) {
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
  ConversationBubble({this.recipient, this.text, this.recipientId});
  final String recipient;
  final String text;
  final String recipientId;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Colors.cyan,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only()),
        child: FlatButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(recipientId)));
          },
          child: Row(
            children: <Widget>[
              Flexible(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(recipient,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                    ),
                    Container(
                      child: Text(text,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    )
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

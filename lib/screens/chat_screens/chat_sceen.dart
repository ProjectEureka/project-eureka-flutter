import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser = EmailAuth().getCurrentUser();

class ChatScreen extends StatefulWidget {
  final String fromId;
  ChatScreen(this.fromId);

  @override
  _ChatScreenState createState() => new _ChatScreenState(fromId);
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String fromId;
  _ChatScreenState(this.fromId);

  String messageText;
  String groupChatId;
  String userId;

  @override
  void initState() {
    super.initState();
    getCurrentuser();
    userId = loggedInUser.uid;

    print(userId);
    print(fromId);
    groupChatId = '$userId-$fromId';
    print(groupChatId);
  }

  void getCurrentuser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
        print(loggedInUser.metadata.lastSignInTime.month);
        print(loggedInUser.metadata.lastSignInTime.day);
        print(loggedInUser.metadata.lastSignInTime.year);
        print(loggedInUser.metadata.lastSignInTime.minute);
        print(loggedInUser.metadata.lastSignInTime.hour);
      }
    } catch (e) {
      print(e);
    }
  }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EurekaAppBar(
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  messagesStream();
                }),
          ],
          backgroundColor: Colors.lightBlueAccent,
        ),
        title: 'Answer Question',
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(groupChatId: groupChatId, fromId: fromId),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      var currentTimeAndDate = DateTime.now();
                      //message text + loggedInuser.email

                      _firestore
                          .collection('messages')
                          .doc(groupChatId)
                          .collection(groupChatId)
                          .add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                        'timestamp': currentTimeAndDate,
                        'idFrom': userId,
                        'idTo': fromId,
                      });
                    },
                    child: Text(
                      'Send',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  final String groupChatId;
  final String fromId;
  MessagesStream({this.groupChatId, this.fromId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        //uses async snapshot
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final messages = snapshot.data.docs;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data()['text'];
          final messageSender = message.data()['sender'];
          //print(loggedInUser.email);

          final currentUser = fromId;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: loggedInUser.email == messageSender,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});
  final String sender;
  final String text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              sender,
              style: TextStyle(fontSize: 12.0, color: Colors.black),
            ),
            Material(
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0))
                  : BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0)),
              elevation: 5.0, //adds shadow
              color: isMe ? Colors.lightBlueAccent : Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: isMe ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ]),
    );
  }
}
//user id: NX3lTrYhiiZfV12WgPlWuUBykqI2
// idFrom: hJGcQsILP7XQDSvWY2Qx2k3MD0V2 victor

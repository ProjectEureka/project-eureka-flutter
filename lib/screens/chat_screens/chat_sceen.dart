import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser = EmailAuth().getCurrentUser();

class ChatScreen extends StatefulWidget {
  final String fromId;
  final String recipient;
  ChatScreen(this.fromId, this.recipient);

  @override
  _ChatScreenState createState() => new _ChatScreenState(fromId, recipient);
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String fromId;
  String recipient;
  _ChatScreenState(this.fromId, this.recipient);

  String messageText;
  String groupChatId;
  String userId;

  @override
  void initState() {
    super.initState();
    getCurrentuser();
    userId = loggedInUser.uid;
    if (fromId == userId) {
      groupChatId = '$userId-$fromId';
    } else {
      groupChatId = '$fromId-$userId';
    }
    print(fromId);
    print(groupChatId);
  }

  setGroupId() {
    if (fromId != userId) {
      groupChatId = '$userId-$fromId';
    } else {
      groupChatId = '$fromId-$userId';
    }
  }

  void getCurrentuser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EurekaAppBar(
          appBar: AppBar(
            leading: null,
            actions: <Widget>[
              IconButton(icon: Icon(Icons.close), onPressed: () {}),
            ],
            backgroundColor: Colors.lightBlueAccent,
          ),
          title: recipient),
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
          final messageTimestamp = message.data()['timestamp'];
          //print(loggedInUser.email);
          print(messageText);
          print(messageSender);
          print(messageTimestamp);
          final messageBubble = MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: loggedInUser.email == messageSender,
              timestamp: messageTimestamp.toDate());
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

String getTime(DateTime dateTime) {
  String formattedTime = DateFormat.jm().format(dateTime);
  return formattedTime;
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe, this.timestamp});
  final String sender;
  final String text;
  final bool isMe;
  final DateTime timestamp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              getTime(timestamp),
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
              color: isMe ? Colors.cyan : Colors.white,

              child: Column(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Container(
                      child: Text(text,
                          style: TextStyle(
                            fontSize: 17.0,
                            color: isMe ? Colors.white : Colors.black,
                          ),
                          textAlign: isMe ? TextAlign.start : TextAlign.end),
                    ),
                  ),
                ],
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              ),
            ),
          ]),
    );
  }
}
//user id: NX3lTrYhiiZfV12WgPlWuUBykqI2
// idFrom: hJGcQsILP7XQDSvWY2Qx2k3MD0V2 victor

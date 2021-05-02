import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';
import 'package:project_eureka_flutter/screens/chat_screens/chat_screen.dart';
import 'package:project_eureka_flutter/models/user_model.dart';
import 'package:project_eureka_flutter/services/users_service.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser = EmailAuth().getCurrentUser();

class ChatScreenConversations extends StatefulWidget {
  @override
  _ChatScreenConversations createState() => _ChatScreenConversations();
}

class _ChatScreenConversations extends State<ChatScreenConversations> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: EurekaAppBar(
          title: 'My Chats',
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
      stream: _firestore
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        //uses async snapshot
        if (!snapshot.hasData) {
          return Column(
            children: [
              Center(
                heightFactor: 30,
                child: Text("Start New Chat from a Question"),
              ),
            ],
          );
        }
        final conversations = snapshot.data.docs;
        List<ConversationBubble> conversationBubbles = [];
        for (var userChat in conversations) {
          final conversationUserID = userChat.data()['chatIDUser'];
          final recipientID = userChat.data()['recipientId'];
          final questionTitle = userChat.data()['questionTitle'];
          final questionID = userChat.data()['questionId'];
          final unseen = userChat.data()['unseen'];
          final groupChatID = userChat.data()['groupChatId'];
          final lastMessageSender = userChat.data()['lastMessageSender'];
          final meInTheRoom = userChat.data()[loggedInUser.uid];
          final recipientInTheRoom = userChat.data()[recipientID];
          //if the user has not seen this message, then this will be true
          final conversationBubble = ConversationBubble(
            questionTitle: questionTitle,
            recipientId: recipientID == loggedInUser.uid
                ? conversationUserID
                : recipientID,
            questionId: questionID,
            unseen: unseen,
            groupId: groupChatID,
            lastMessageSender: lastMessageSender,
            enteredChat: enteredChat,
          );
          if (conversationUserID == loggedInUser.uid ||
              recipientID == loggedInUser.uid) {
            conversationBubbles.add(conversationBubble);
          }
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            children: conversationBubbles,
          ),
        );
      },
    );
  }
}

Future<UserModel> initGetUserDetails(recipientId) async {
  UserModel payload = await UserService().getUserById(recipientId);
  return payload;
}

class ConversationBubble extends StatelessWidget {
  ConversationBubble({
    this.recipientId,
    this.questionTitle,
    this.questionId,
    this.unseen,
    this.groupId,
    this.lastMessageSender,
    this.enteredChat,
  });
  final String recipientId;
  final String questionTitle;
  final String questionId;
  final bool unseen;
  final String groupId;
  final String lastMessageSender;
  final bool enteredChat;


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
        future: initGetUserDetails(recipientId),
        builder: (context, AsyncSnapshot<UserModel> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                decoration: BoxDecoration(
                    color: Colors.cyan,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: FlatButton(
                  onPressed: () {
                    if(unseen && lastMessageSender != loggedInUser.uid) {
                      _firestore
                          .collection('messages')
                          .doc(groupId)
                          .update({'unseen': false});
                    }
                    _firestore
                        .collection('messages')
                        .doc(groupId)
                        .update({loggedInUser.uid: true});
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                  fromId: recipientId,
                                  recipient: snapshot.data.firstName +
                                      " " +
                                      snapshot.data.lastName,
                                  questionId: questionId,
                                  lastMessageSender: lastMessageSender,
                                  enteredChat: enteredChat,
                                )));
                  },
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Colors.white,
                        backgroundImage: snapshot.data.pictureUrl == ''
                            ? AssetImage(
                                'assets/images/profile_default_image.png')
                            : NetworkImage(snapshot.data.pictureUrl),
                      ),
                      Flexible(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                  snapshot.data.firstName +
                                      " " +
                                      snapshot.data.lastName,
                                  style: TextStyle(
                                      color: Color(0xFF25291C),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                            ),
                            Container(
                              child: Text(questionTitle,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontStyle: (unseen &&
                                              (lastMessageSender !=
                                                  loggedInUser.uid))
                                          ? FontStyle.italic
                                          : FontStyle.normal,
                                      fontSize: 16,
                                      fontWeight: (unseen &&
                                              (lastMessageSender !=
                                                  loggedInUser.uid) &&
                                              !enteredChat)
                                          ? FontWeight.bold
                                          : FontWeight.normal)),
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 10.0),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.fiber_manual_record_rounded,
                          color: (unseen &&
                                  (lastMessageSender != loggedInUser.uid) &&
                                  !enteredChat)
                              ? Colors.white
                              : Colors.cyan,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

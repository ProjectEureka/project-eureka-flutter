import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';

import 'chat_sceen.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser = EmailAuth().getCurrentUser();

class ChatScreenConversations extends StatefulWidget {
  @override
  _ChatScreenConversations createState() => _ChatScreenConversations();
}

class _ChatScreenConversations extends State<ChatScreenConversations> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("Start a New chat in the Questions Page"),
            );
          } else {
            final allConversations = snapshot.data.docs;
            final sortedConvos = [];
            for (var convo in allConversations) {
              final convoText = convo.data()['text'];
              final convoSender = convo.data()['sender'];
            }

            // return ListView.builder(
            //   padding: EdgeInsets.all(10.0),
            //   itemBuilder: (context, index) =>
            //       buildItem(context, snapshot.data.docs[index]),
            //   itemCount: snapshot.data.docs.length,
            // );
          }
        },
      ),
    );
  }
}

// Widget buildItem(BuildContext context, DocumentSnapshot snapshot) {
//   if (snapshot.data()['idTo'] == loggedInUser) {
//     return Container();
//   } else {
//     return Container(
//       child: FlatButton(
//         onPressed: () {
//           Navigator.push(
//               context, MaterialPageRoute(builder: (context) => ChatScreen()));
//         },
//         child: Row(
//           children: <Widget>[
//             Flexible(
//                 child: Container(
//               child: Column(
//                 children: <Widget>[
//                   Container(
//                     child: Text(
//                       snapshot.data()['sender'],
//                       style: TextStyle(color: Colors.black),
//                     ),
//                     alignment: Alignment.centerLeft,
//                     margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
//                   ),
//                   Container(
//                     child: Text(
//                       snapshot.data()['text'],
//                       style: TextStyle(color: Colors.black),
//                     ),
//                     alignment: Alignment.centerLeft,
//                     margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
//                   ),
//                 ],
//               ),
//             ))
//           ],
//         ),
//         color: Colors.grey,
//         padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//       ),
//       margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
//     );
//   }
//}

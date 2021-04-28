import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_eureka_flutter/models/user_model.dart';
import 'package:project_eureka_flutter/screens/call_screens/call_page.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';
import 'package:project_eureka_flutter/services/users_service.dart';
import 'package:project_eureka_flutter/services/video_communication.dart';
import 'dart:math';

// Initialize global variable for channel name for the call receiver; accessible for in ChatScreen and MessageBubble classes
String channelNameAnswer = "";

class ChatScreen extends StatefulWidget {
  final String fromId;
  final String recipient;
  final String questionId;
  const ChatScreen({Key key, this.fromId, this.recipient, this.questionId})
      : super(key: key);

  @override
  _ChatScreenState createState() => new _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User loggedInUser = EmailAuth().getCurrentUser();

  String messageText;
  String groupChatId;
  String userId;
  // Initialize channel name on caller's side
  String channelNameCall = "";
  // initialize token on the caller's side that will be requested from the backend
  String _tokenCall = "";
  // used to get the user's firstName fir the system message when starting the call
  UserModel user = new UserModel(
    firstName: '',
  );
  // Used for the animated video call button to turn off / turn on animation
  bool showAnimationButton;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    userId = loggedInUser.uid;
    groupChatId = userId + "-" + widget.fromId + "-" + widget.questionId;
    setGroupId();

    // initialize channel names for two cases:
    // 1: channelNameCall - user calls and joins the channel; (initialized to empty string)
    // 2: channelNameAnswer - user clicks answer and joins the created channel
    channelNameAnswer = widget.fromId + "-" + userId;

    UserService().getUserById(userId).then((payload) {
      setState(() {
        user = payload;
      });
    });

    _controller = new AnimationController(
      vsync: this,
    );
    _controller.repeat(
      period: Duration(seconds: 1),
    );
    showAnimationButton = false;
    _checkAnswerToken();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // check if call has been started - every 3 seconds
  // that will start the animated video call button
  void _checkAnswerToken() async {
    while (true) {
      if (!mounted) {
        // once left the chat page, break the loop
        break;
      }
      // listen to answerToken every 4 seconds
      await Future.delayed(new Duration(seconds: 4));
      await VideoCallService().getTokenAnswer(channelNameAnswer).then(
        (payload) {
          if (!mounted)
            return; // allow last call check to complete and prevent setState
          payload != "error"
              ? setState(() => showAnimationButton = true)
              : setState(() => showAnimationButton = false);
        },
      );
    }
  }

  void setGroupId() async {
    List<String> groupChatIds = [];
    _firestore.collection('messages').get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        groupChatIds.add(result.id.toString());
      });

      if (!groupChatIds.contains(groupChatId)) {
        setState(() {
          groupChatId = widget.fromId + "-" + userId + "-" + widget.questionId;
        });
      }
    });
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  // create and receive token after starting the call
  Future<void> initGetTokenCall() async {
    channelNameCall = userId + "-" + widget.fromId;
    String tokenAnswer = "";
    // first check if call has already been started by another user
    await VideoCallService().getTokenAnswer(channelNameAnswer).then(
      (payload) {
        tokenAnswer = payload;
      },
    );
    // if call wasn't started, start the call
    // otherwise, join the existing call
    if (tokenAnswer == "error") {
      await VideoCallService().getTokenCall(channelNameCall).then(
        (payload) {
          setState(() {
            _tokenCall = payload;
          });
        },
      );
    } else {
      channelNameCall = channelNameAnswer;
      _tokenCall = tokenAnswer;
    }
  }

  Future<void> callUser() async {
    await initGetTokenCall();
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
    // this message will be sent from caller's side after call is finished
    if (channelNameCall != channelNameAnswer)
      _firestore
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .add({
        'text': user.firstName + " started the call",
        'sender': "system - " + userId,
        'timestamp': DateTime.now(),
        'idFrom': userId,
        'idTo': widget.fromId,
      });
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          token: _tokenCall,
          channelName: channelNameCall,
          action: "call",
        ),
      ),
    );
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EurekaAppBar(
          appBar: AppBar(),
          actions: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: [
                showAnimationButton
                    ? Container(
                        alignment: Alignment(0, 0.15),
                        child: CustomPaint(
                          painter: new SpritePainter(_controller),
                          child: new SizedBox(
                            width: 80.0,
                            height: 80.0,
                          ),
                        ),
                      )
                    : Container(
                        alignment: Alignment(0, 0.15),
                        child: CustomPaint(
                          child: new SizedBox(
                            width: 80.0,
                            height: 80.0,
                          ),
                        ),
                      ),
                IconButton(
                    icon: Icon(Icons.photo_camera_front, size: 40.0),
                    onPressed: () async {
                      await callUser();
                      if (channelNameCall != channelNameAnswer) {
                        _firestore
                            .collection('messages')
                            .doc(groupChatId)
                            .collection(groupChatId)
                            .add({
                          'text': "Call ended",
                          'sender': "system",
                          'timestamp': DateTime.now(),
                          'idFrom': userId,
                          'idTo': widget.fromId,
                        });
                      }
                    }),
              ],
            ),
            SizedBox(width: 30.0)
            //camera button for call will go here
          ],
          title: widget.recipient),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
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
                  final messageBubble = MessageBubble(
                      sender: messageSender,
                      text: messageText,
                      isMe: loggedInUser.email == messageSender,
                      // if sender String contains "system", this message will appear in the center (it is a system message)
                      isSystem: messageSender.contains("system"),
                      // if sender String contains caller's ID, show Answer button. Caller won't see answer button
                      showAnswerButton: messageSender.contains(widget.fromId),
                      timestamp: messageTimestamp.toDate());
                  messageBubbles.add(messageBubble);
                }
                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                    children: messageBubbles,
                  ),
                );
              },
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding:
                  EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                      minLines: 1,
                      maxLines: 5,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)),
                    color: Colors.cyan,
                    onPressed: () {
                      messageTextController.clear();
                      var currentTimeAndDate = DateTime.now();
                      _firestore
                          .collection('messages')
                          .doc(groupChatId)
                          .collection(groupChatId)
                          .add({
                        'text': messageText.trim(),
                        'sender': loggedInUser.email,
                        'timestamp': currentTimeAndDate,
                        'idFrom': userId,
                        'idTo': widget.fromId,
                      });
                    },
                    child: Text(
                      'Send',
                      style: TextStyle(color: Colors.white),
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

String getTime(DateTime dateTime) {
  String formattedTime = DateFormat.jm().format(dateTime);
  String formattedDate = DateFormat.MMMMd().format(dateTime);
  return formattedDate + ', ' + formattedTime;
}

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {this.sender,
      this.text,
      this.isMe,
      this.isSystem,
      this.timestamp,
      this.showAnswerButton});
  final String sender;
  final String text;
  final bool isMe;
  final bool isSystem;
  final bool showAnswerButton;
  final DateTime timestamp;

  // Answer call from the button tha appears in chat
  Future<String> answerCall() async {
    String tokenAnswer = "";
    await VideoCallService().getTokenAnswer(channelNameAnswer).then(
      (payload) {
        tokenAnswer = payload;
      },
    );
    if (tokenAnswer != "error") {
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      return tokenAnswer;
    }
    return tokenAnswer;
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : isSystem
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
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
                  : isSystem
                      ? BorderRadius.all(Radius.circular(30.0))
                      : BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0)),
              elevation: 5.0, //adds shadow
              color: isMe
                  ? Colors.cyan
                  : isSystem
                      ? Colors.white
                      : Colors.white,

              child: Column(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Container(
                      child: Text(text,
                          style: TextStyle(
                            fontSize: 17.0,
                            color: isMe
                                ? Colors.white
                                : isSystem
                                    ? Colors.blue
                                    : Colors.black,
                          ),
                          textAlign: TextAlign.start),
                    ),
                  ),
                ],
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              ),
            ),

            // Answer button when call started by another user.
            // Button will stay in chat, however won't work if call is not active
            if (showAnswerButton & isSystem & text.contains('started the call'))
              SizedBox.fromSize(
                size: Size(70, 56), // button width and height
                child: Material(
                  color: Colors.transparent, // button color
                  child: InkWell(
                    splashColor: Colors.blueGrey, // splash color
                    onTap: () async {
                      String tokenAnswer = await answerCall();
                      // Show alert if token was expired (call ended)
                      if (tokenAnswer == "error")
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text('Error'),
                                  content: Text(
                                    'Call is inactive.',
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Close')),
                                  ],
                                ));
                      // if token received, join the call
                      if (tokenAnswer != "error")
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CallPage(
                              token: tokenAnswer,
                              channelName: channelNameAnswer,
                              action: "answer",
                            ),
                          ),
                        );
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.photo_camera_front, size: 30.0), // icon
                        Text("Answer",
                            style: TextStyle(fontSize: 17.0)), // text
                      ],
                    ),
                  ),
                ),
              )
          ]),
    );
  }
}

// Used for animated video call button when receiving the call
class SpritePainter extends CustomPainter {
  final Animation<double> _animation;

  SpritePainter(this._animation) : super(repaint: _animation);

  void circle(Canvas canvas, Rect rect, double value) {
    double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    Color color = new Color.fromRGBO(0, 117, 194, opacity);
    double size = rect.width / 2;
    double area = size * size;
    double radius = sqrt(area * value / 4);
    final Paint paint = new Paint()..color = color;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = new Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + _animation.value);
    }
  }

  @override
  bool shouldRepaint(SpritePainter oldDelegate) {
    return true;
  }
}

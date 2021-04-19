import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/components/side_menu.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';
import 'package:project_eureka_flutter/services/video_communication.dart';
import 'package:project_eureka_flutter/components/call_page.dart';

class VideoCommunication extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<VideoCommunication> {
  // Once called, server will associate token with the user id of the caller
  // Once merged with the Chat screen, user id of the companion will be available
  final User _currentUser = EmailAuth().getCurrentUser();
  final String _companionId = "targetuserid";

  // chanel name is the caller's user id
  String _channelController = "";

  // initialize tokens that will be requested from the backend
  String _tokenCall = "";
  String _tokenAnswer = "";

  @override
  void initState() {
    _channelController = _currentUser.uid + _companionId;
    super.initState();
  }

  Future<void> initGetTokenCall() async {
    // will be later companion+currentUser.uid, for the user who answers call
    await VideoCallService().getTokenCall(_channelController).then(
      (payload) {
        setState(() {
          _tokenCall = payload;
        });
      },
    );
  }

  Future<void> initGetTokenAnswer() async {
    await VideoCallService().getTokenAnswer(_channelController).then(
      (payload) {
        setState(() {
          _tokenAnswer = payload;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: EurekaAppBar(
        title: 'Video Call',
        appBar: AppBar(),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 400,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                      onPressed: callUser,
                      child: Text('Call'),
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                    ),
                    RaisedButton(
                      onPressed: //answerCall,
                          () async {
                        await answerCall();
                        // Once call is ended, answer button must not work.
                        // Thus, if server returned error due the not active call (or if token is empty), display an error message
                        if (_tokenAnswer == "error")
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
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('Close')),
                                    ],
                                  ));
                      },
                      child: Text('Answer'),
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> callUser() async {
    await initGetTokenCall();
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          token: _tokenCall,
          channelName: _channelController,
          action: "call",
        ),
      ),
    );
  }

  Future<void> answerCall() async {
    await initGetTokenAnswer();
    if (_tokenAnswer != "error") {
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            token: _tokenAnswer,
            channelName: _channelController,
            action: "answer",
          ),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}

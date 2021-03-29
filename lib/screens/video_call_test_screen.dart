import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_eureka_flutter/components/eureka_appbar.dart';
import 'package:project_eureka_flutter/components/side_menu.dart';
import 'package:project_eureka_flutter/services/email_auth.dart';
import 'package:project_eureka_flutter/services/video_communication.dart';

import '../components/call_page.dart';

class VideoCommunication extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<VideoCommunication> {
  final User user = EmailAuth().getCurrentUser();

  String _channelController = "";
  String _token = "";

  ClientRole _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    _channelController = user.uid;
    super.dispose();
  }

  Future<void> initGetTokenCall() async {
    await VideoCallService().getTokenCall(user.uid).then(
      (payload) {
        setState(() {
          _token = payload;
        });
      },
    );
  }

  Future<void> initGetTokenAnswer() async {
    await VideoCallService().getTokenAnswer(user.uid).then(
          (payload) {
        setState(() {
          _token = payload;
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
                        onPressed: answerCall,
                        child: Text('Answer'),
                        color: Colors.blueAccent,
                        textColor: Colors.white,
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

  Future<void> callUser() async {
    await initGetTokenCall();
    dispose();
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          token: _token,
          channelName: _channelController,
          role: _role,
        ),
      ),
    );
  }

  Future<void> answerCall() async {
    await initGetTokenAnswer();
    dispose();
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          token: _token,
          channelName: _channelController,
          role: _role,
        ),
      ),
    );
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    //print(status);
  }
}

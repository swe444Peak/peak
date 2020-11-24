import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageHandler extends StatefulWidget {
  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
    void initState() {
        super.initState();
        _fcm.configure(
          onMessage: (Map<String, dynamic> message) async {
            print("onMessage: $message");
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                        content: ListTile(
                        title: Text(message['notification']['title']),
                        subtitle: Text(message['notification']['body']),
                        ),
                        actions: <Widget>[
                        FlatButton(
                            child: Text('Ok'),
                            onPressed: () => Navigator.of(context).pop(),
                        ),
                    ],
                ),
            );
         },
        onLaunch: (message) async {
            Navigator.pushNamed(context, "goalInvitations");
        },
        onResume: (message) async {
            Navigator.pushNamed(context, "goalInvitations");
         
        },
      );
        
    }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  

}
import 'package:flutter/material.dart';
import 'package:peak/screens/shared/base.dart';

class GoalInvitations extends StatefulWidget {
  @override
  _GoalInvitationsState createState() => _GoalInvitationsState();
}

class _GoalInvitationsState extends State<GoalInvitations> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(tabs: [
            Tab(
              text: "Received",
            ),
            Tab(
              text: "Sent",
            )
          ]),
          title: Text(
            "Invitations",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: Color.fromRGBO(23, 23, 85, 1.0),
        body: Stack(
          children: [
            Container(
              width: width * 0.8,
              height: width * 0.6,
              margin: EdgeInsets.fromLTRB(0, 0.0, width * 0.2, 0.0),
              decoration: BoxDecoration(
                  color: Colors.indigo[500],
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(400)),
                  gradient: LinearGradient(colors: [
                    Colors.teal[400],
                    Colors.indigo[600],
                    Colors.deepPurple[900]
                  ], begin: Alignment.topLeft, end: Alignment.bottomCenter)),
            ),
            Container(
              child: TabBarView(
                  children: [ReceivedInvitations(), SentInvitations()]),
            ),
          ],
        ),
      ),
    );
  }
}

class SentInvitations extends StatefulWidget {
  @override
  _SentInvitationsState createState() => _SentInvitationsState();
}

class _SentInvitationsState extends State<SentInvitations> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ReceivedInvitations extends StatefulWidget {
  @override
  _ReceivedInvitationsState createState() => _ReceivedInvitationsState();
}

class _ReceivedInvitationsState extends State<ReceivedInvitations> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Received")),
    );
  }
}

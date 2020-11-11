import 'package:flutter/material.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/models/user.dart';
import 'package:peak/viewmodels/sentInvitations_model.dart';
import 'package:stacked/stacked.dart';
import 'package:peak/models/Invitation.dart';
import 'package:peak/enums/InvationStatus.dart';

import '../locator.dart';

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

class SentInvitations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return ViewModelBuilder<SentInvitationsModel>.reactive(
      viewModelBuilder: () => locator<SentInvitationsModel>(),
      onModelReady: (model) => model.readSentInvitations(),
      builder: (context, model, child) => Container(
        child: model.state == ViewState.Busy
            ? Center(
                child: CircularProgressIndicator(),
              )
            : model.empty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "Your Goals list is empty\n Start adding new Goals!",
                        style: TextStyle(
                            fontSize: width * 0.06, color: Colors.white),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: model.goalDoc.length, // goal doc id
                    itemBuilder: (context, index) => getCard(model, index),
                  ),
      ),
    );
  }

  Widget getCard(model, index) {
    List<Invitation> invitations = model.getInvitations(model.goalDoc[index]);
    return Card(
      elevation: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ExpansionTile(
        title: Text(
          invitations.first.goalName,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
        subtitle: Row(
          children: [
            Icon(
              Icons.assistant_photo,
              color: Colors.amber,
            ),
            Text(
                "${invitations.first.goalDueDate.day}/${invitations.first.goalDueDate.month}/${invitations.first.goalDueDate.year}"),
            Icon(
              Icons.assignment_turned_in,
              color: Colors.teal,
            ),
            Text("${invitations.first.numOfTasks}"),
          ],
        ),
        children: List<Widget>.generate(
          invitations.length,
          (int index) => ReceiverStatus(
            invitation: invitations[index],
            user: model.getUser(invitations[index].receiverId),
          ),
        ),
      ),
    );
  }
}

class ReceiverStatus extends StatelessWidget {
  final Invitation invitation;
  final PeakUser user;

  ReceiverStatus({this.invitation, this.user});
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return Container(
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: ListTile(
          title: Text(user.name),
          subtitle: Text("Status: ${invitation.status.toShortString()}"),
          leading: Container(
            padding:
                EdgeInsets.fromLTRB(0.0, height * 0.008, 0.0, height * 0.008),
            width: width * 0.15,
            height: width * 0.15,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(user.picURL),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                new BoxShadow(
                  color: Colors.black26,
                  offset: new Offset(0.0, -8.0),
                  blurRadius: 40.0,
                  spreadRadius: 1.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
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

import 'package:flutter/material.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/locator.dart';
import '../locator.dart';
import 'package:peak/models/Invitation.dart';
import 'package:peak/services/dialogService.dart';
import 'package:peak/viewmodels/receivedInvitations_model.dart';
import 'package:stacked/stacked.dart';

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
  DialogService dialogService = locator<DialogService>();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return ViewModelBuilder<ReceivedInvitationsModel>.reactive(
        viewModelBuilder: () => locator<ReceivedInvitationsModel>(),
        onModelReady: (model) => model.readInvitations(),
        builder: (context, model, child) => Container(
              width: width * 0.9,
              height: height * 0.7,
              child: (model.state == ViewState.Busy)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: model.invitations.length,
                      itemBuilder: (context, index) {
                        Invitation invitation = model.invitations[index];
                        return Card(
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.fromLTRB(width * 0.05,
                                height * 0.02, 0.0, height * 0.01),
                            title: Text(
                              invitation.goalName,
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      0.0, height * 0.01, 0.0, height * 0.01),
                                  child: Row(
                                    children: [
                                      Container(
                                        //due date
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.008),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.assistant_photo,
                                              color: Colors.amber,
                                            ),
                                            Text(
                                                "${invitation.goalDueDate.day}/${invitation.goalDueDate.month}/${invitation.goalDueDate.year}"),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        //Tasks
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.008),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.assignment_turned_in,
                                              color: Colors.teal,
                                            ),
                                            Text("${invitation.numOfTasks}"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ), //end of subtitle
                            trailing: Row(
                              children: [
                                IconButton(
                                    icon: Icon(Icons.check_circle),
                                    color: Colors.green,
                                    onPressed: () {
                                      bool result = model.acceptGoalInvite(
                                          new Invitation(
                                              creatorId: invitation.creatorId,
                                              receiverId: invitation.receiverId,
                                              status: invitation.status,
                                              creatorgoalDocId:
                                                  invitation.creatorgoalDocId,
                                              invationDocId:
                                                  invitation.invationDocId,
                                              goalName: invitation.goalName,
                                              goalDueDate: new DateTime(
                                                  invitation.goalDueDate.year,
                                                  invitation.goalDueDate.month,
                                                  invitation.goalDueDate.day),
                                              numOfTasks:
                                                  invitation.numOfTasks));
                                      if (result) {
                                        dialogService.showDialog(
                                            title: "Hooray!!",
                                            description:
                                                "You have a new shared goal waitting for you in your goals list, go ahead and achieve it");
                                      }
                                    }),
                                IconButton(
                                    icon: Icon(Icons.cancel),
                                    color: Colors.red,
                                    onPressed: () async{
                                      var declineDialogResponse =
                                          await dialogService.showConfirmationDialog(
                                        title: 'Declie Invitation',
                                        description:
                                            'Are you sure you want to decline ${invitation.goalName} invitation?',
                                        confirmationTitle: 'Yes',
                                        cancelTitle: 'No',
                                      );
                                      if (declineDialogResponse.confirmed){
                                        bool result = model.declinedGoalInvite(
                                            new Invitation(
                                                creatorId: invitation.creatorId,
                                                receiverId:
                                                    invitation.receiverId,
                                                status: invitation.status,
                                                creatorgoalDocId:
                                                    invitation.creatorgoalDocId,
                                                invationDocId:
                                                    invitation.invationDocId,
                                                goalName: invitation.goalName,
                                                goalDueDate: new DateTime(
                                                    invitation.goalDueDate.year,
                                                    invitation
                                                        .goalDueDate.month,
                                                    invitation.goalDueDate.day),
                                                numOfTasks:
                                                    invitation.numOfTasks));
                                      if (result) {
                                        dialogService.showDialog(
                                            title: "Maybe next time",
                                            description:
                                                "It's Wise to choose your fights carefully");
                                      }}
                                    }),
                              ],
                            ),
                          ),
                        );
                      }),
            ));
  }
}

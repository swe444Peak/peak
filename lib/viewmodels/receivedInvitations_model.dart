import 'package:flutter/material.dart';
import 'package:peak/enums/InvationStatus.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/models/Invitation.dart';
import 'package:peak/models/goal.dart';
import 'package:peak/models/task.dart';
import 'package:peak/services/databaseServices.dart';

import '../locator.dart';

class ReceivedInvitationsModel extends ChangeNotifier {
  final _firstoreService = locator<DatabaseServices>();
  ViewState _state = ViewState.Idle;
  List<Invitation> _invitations;

  ViewState get state => _state;
  List<Invitation> get invitations => _invitations;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  void readInvitations(){
    setState(ViewState.Busy);
    // Goal goal = Goal(goalName: "user1 goal2", uID: "W8RKLSV8Gya8NN5Qx9FbovYBlxV2", deadline: DateTime(2020,11,15), creationDate: DateTime(2020,7,15), tasks: [DailyTask(taskName: "null",creationDate: DateTime(2020,7,15))],competitors: [],);
    // Invitation inv = Invitation(creatorId: "W8RKLSV8Gya8NN5Qx9FbovYBlxV2", receiverId: "DZr1HX3nOEZlvLSjaEMCZ9Uvag43",status: InvationStatus.Pending,goalName: goal.goalName,goalDueDate: goal.deadline,numOfTasks: goal.numOfTasks);
    // _firstoreService.inviteFriends([inv], goal);
    _firstoreService.getReceivedInvations().listen((invitationData) {
      if(invitationData.isNotEmpty){
        print("inv: $_invitations     dat: $invitationData");
        _invitations = invitationData;
      }
      notifyListeners();
      setState(ViewState.Idle);
     }, onError: (error) => print(error));
  }//end readInvitations()

  bool acceptGoalInvite(Invitation invitation){
    setState(ViewState.Busy);
    dynamic result;
    result = _firstoreService.acceptGoalInvite(invitation);
    if(result == true){
      setState(ViewState.Idle);
      return true;
    }else{
      print(result);
      setState(ViewState.Idle);
      return false;
    }//end else
  }//end acceptGoalInvite()

  bool declinedGoalInvite(Invitation invitation){
    setState(ViewState.Busy);
    dynamic result;
    result = _firstoreService.declinedGoalInvite(invitation);
    if(result == true){
      setState(ViewState.Idle);
      return true;
    }else{
      print(result);
      setState(ViewState.Idle);
      return false;
    }//end else
  }//end declinedGoalInvite()
}

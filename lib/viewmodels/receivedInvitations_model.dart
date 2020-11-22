import 'package:flutter/material.dart';

import 'package:peak/enums/viewState.dart';
import 'package:peak/models/Invitation.dart';
import 'package:peak/models/goal.dart';

import 'package:peak/services/databaseServices.dart';

import '../locator.dart';

class ReceivedInvitationsModel extends ChangeNotifier {
  final _firstoreService = locator<DatabaseServices>();
  ViewState _state = ViewState.Idle;
  List<Invitation> _invitations;
  List<Goal> goals;

  ViewState get state => _state;
  List<Invitation> get invitations => _invitations;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  void readInvitations() {
    setState(ViewState.Busy);
    List<String> goalIds = [];
    // Goal goal = Goal(
    //   goalName: "EDIT GOAL",
    //   uID: "W8RKLSV8Gya8NN5Qx9FbovYBlxV2",
    //   deadline: DateTime(2020, 11, 15),
    //   creationDate: DateTime.now(),
    //   tasks: [DailyTask(taskName: "t1", creationDate: DateTime.now())],
    //   competitors: [],
    // );
    // Invitation inv = Invitation(
    //     creatorId: "W8RKLSV8Gya8NN5Qx9FbovYBlxV2",
    //     receiverId: "DZr1HX3nOEZlvLSjaEMCZ9Uvag43",
    //     status: InvationStatus.Pending,
    //     goalName: goal.goalName,
    //     goalDueDate: goal.deadline,
    //     numOfTasks: goal.numOfTasks);

    // _firstoreService.inviteFriends([inv], goal);

    _firstoreService.getReceivedInvations().listen((invitationData) async {
      if (invitationData.isNotEmpty) {
        _invitations = invitationData;
        _invitations.forEach((element) {
          goalIds.add(element.creatorgoalDocId);
        });
        goals = await _firstoreService.getCertainGoals(goalIds);
      }
      notifyListeners();
      setState(ViewState.Idle);
    }, onError: (error) => print(error));
  } //end readInvitations()

  Future<bool> acceptGoalInvite(Invitation invitation) async {
    setState(ViewState.Busy);
    dynamic result;

    result = await _firstoreService.acceptGoalInvite(invitation);
    if (result == true) {
      notifyListeners();
      setState(ViewState.Idle);
      return true;
    } else {
      print(result);
      setState(ViewState.Idle);
      return false;
    } //end else
  } //end acceptGoalInvite()

  Future<bool> declinedGoalInvite(Invitation invitation) async {
    setState(ViewState.Busy);
    dynamic result;
    result = await _firstoreService.declinedGoalInvite(invitation);
    if (result == true) {
      notifyListeners();
    }
    setState(ViewState.Idle);
  }
}

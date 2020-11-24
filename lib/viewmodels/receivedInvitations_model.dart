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
  bool empty = false;
  ViewState get state => _state;
  List<Invitation> get invitations => _invitations;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  void readInvitations() {
    setState(ViewState.Busy);
    List<String> goalIds = [];

    _firstoreService.getReceivedInvations().listen((invitationData) async {
      List<Invitation> updatedInvitations = invitationData;
      if (updatedInvitations != null && updatedInvitations.length > 0) {
        _invitations = updatedInvitations;
        _invitations.forEach((element) {
          goalIds.add(element.creatorgoalDocId);
        });
        goals = await _firstoreService.getCertainGoals(goalIds);
        empty = false;
      }else{
        empty = true;
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

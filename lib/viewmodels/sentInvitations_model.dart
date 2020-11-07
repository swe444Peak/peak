import 'package:flutter/material.dart';
import 'package:peak/models/Invitation.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/models/user.dart';
import 'package:peak/services/databaseServices.dart';

import '../locator.dart';

class SentInvitationsModel extends ChangeNotifier {
  final _firstoreService = locator<DatabaseServices>();
  ViewState _state = ViewState.Idle;
  List<Invitation> invitations;
  bool empty = false;
  List<PeakUser> users;
  List<String> goalDoc;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  void readSentInvitations() {
    users = [];
    List<String> userIds = [];
    setState(ViewState.Busy);
    _firstoreService.getSentInvations().listen((invitationData) {
      List<Invitation> updatedInvations = invitationData;
      if (updatedInvations != null) {
        if (updatedInvations.length > 0) {
          empty = false;

          invitations = updatedInvations;

          invitations.forEach((element) {
            if (userIds.length < 10)
              userIds.add(element.receiverId);
            else {
              List<PeakUser> fetchedUsers = _firstoreService.getUsers(userIds);
              users.addAll(fetchedUsers);
              userIds = [];
            }
          });
          filterInvitations();
        } else {
          empty = true;
        }
        notifyListeners();
      }
      setState(ViewState.Idle);
    });
  }

  void filterInvitations() {
    goalDoc = [];
    invitations.forEach((element) {
      if (!goalDoc.contains(element.creatorgoalDocId))
        goalDoc.add(element.creatorgoalDocId);
    });
  }

  List<Invitation> getInvitations(String goalDocId) {
    return invitations
        .where((element) => element.creatorgoalDocId == goalDocId);
  }

  PeakUser getUser(String uid) =>
      users.firstWhere((element) => element.uid == uid);
}

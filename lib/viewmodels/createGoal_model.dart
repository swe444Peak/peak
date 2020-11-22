import 'package:flutter/material.dart';
import 'package:peak/enums/InvationStatus.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/models/Invitation.dart';
import 'package:peak/models/badges.dart';
import 'package:peak/models/user.dart';
import 'package:peak/models/validationItem.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/models/goal.dart';
import 'package:peak/models/task.dart';
import 'package:peak/services/firebaseAuthService.dart';
import 'package:peak/services/googleCalendar.dart';
import 'package:random_string/random_string.dart';

import '../locator.dart';

class CreateGoalModel extends ChangeNotifier {
  ValidationItem _goalName = ValidationItem(null, null);
  ValidationItem _dueDate = ValidationItem(null, null);

  final _firstoreService = locator<DatabaseServices>();
  final _firebaseService = locator<FirbaseAuthService>();
  ViewState _state = ViewState.Idle;
  PeakUser user;
  ValidationItem get goalName => _goalName;
  ValidationItem get dueDate => _dueDate;
  final googleCalendar = locator<GoogleCalendar>();

  bool get isValid => goalName.value != null && _dueDate.value != null;
  String result;
  ViewState get state => _state;
  final _firebaseAuthService = locator<FirbaseAuthService>();
  final _firebaceService = locator<DatabaseServices>();

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  void setGoalName(String goalName) {
    if (goalName.trim().isEmpty) {
      _goalName = ValidationItem(null, "goal name is required");
    } else {
      _goalName = ValidationItem(goalName, null);
    }
    notifyListeners();
  }

  void setDueDate(String dueDate) {
    if (dueDate.trim().isEmpty) {
      _dueDate = ValidationItem(null, "goal due date is required");
    } else {
      _dueDate = ValidationItem(dueDate, null);
    }
    notifyListeners();
  }

  Future createGoal(String goalName, String uID, DateTime deadLine,
      List<Task> tasks, List<PeakUser> addedFriends) async {
    setState(ViewState.Busy);
    if (addedFriends != null && addedFriends.length > 0) {
      List<Invitation> invitations = [];

      Goal goal = Goal(
          goalName: goalName,
          uID: uID,
          deadline: deadLine,
          tasks: tasks,
          creationDate: DateTime.now(),
          competitors: [],
          creatorId: uid());

      addedFriends.forEach((element) {
        invitations.add(Invitation(
          creatorId: uid(),
          receiverId: element.uid,
          status: InvationStatus.Pending,
          goalName: goal.goalName,
          goalDueDate: goal.deadline,
          numOfTasks: goal.numOfTasks,
        ));
      });
      result = await _firstoreService.inviteFriends(invitations, goal);
    } else {
      Goal goal = Goal(
          goalName: goalName,
          uID: uID,
          deadline: deadLine,
          tasks: tasks,
          creationDate: DateTime.now());

      result = await _firstoreService.addGoal(goal: goal);
    }
    setState(ViewState.Idle);
    return result;
  }

  Future addGoalToGoogleCalendar(
      String name, DateTime startDate, DateTime endDate) async {
    await googleCalendar.setEvent(name, startDate, endDate);
  }

  uPdateEventId() {
    _firebaceService.updateEventId(result);
  }

  bool updateBadge() {
    user = _firebaseAuthService.currentUser;
    Badge oldBadge;
    user.badges.forEach((badge) {
      if (badge.name.compareTo("First goal") == 0) oldBadge = badge;
    });

    Badge newBadge = Badge(
      name: oldBadge.name,
      description: oldBadge.description,
      goal: oldBadge.goal,
      counter: oldBadge.counter,
      status: oldBadge.status,
      dates: List.from(oldBadge.dates),
    );
    bool update = newBadge.updateStatus();
    if (update) {
      user.badges.remove(oldBadge);
      user.badges.add(newBadge);
      _firebaceService.updateBadge(oldBadge, newBadge);
      return newBadge.status;
    }
    return false;
  }

  String uid() {
    if (_firebaseService.currentUser != null)
      return _firebaseService.currentUser.uid;
  }
}

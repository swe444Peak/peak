import 'package:flutter/material.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/models/validationItem.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/models/goal.dart';
import 'package:peak/models/task.dart';
import 'package:peak/services/dialogService.dart';
import 'package:peak/services/googleCalendar.dart';

import '../locator.dart';

class EditGoalModel extends ChangeNotifier {
  DialogService _dialogService = locator<DialogService>();
  final _firstoreService = locator<DatabaseServices>();
  final googleCalendar = locator<GoogleCalendar>();
  ValidationItem _goalName = ValidationItem("l", null);
  ValidationItem _dueDate = ValidationItem("r", null);

  ViewState _state = ViewState.Idle;

  ValidationItem get goalName => _goalName;
  ValidationItem get dueDate => _dueDate;

  bool get isValid => goalName.value != null && _dueDate.value != null;

  ViewState get state => _state;

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

  Future updateGoal(String goalName, DateTime creationDate, DateTime deadline,
      List<Task> tasks, String docID, String eventId,String creatorId,List<String>competitors ) async {
    int numOfTasks = 0;
    tasks.forEach((element) {
      numOfTasks += element.taskRepetition;
    });

    Goal updatedGoal = Goal(
        goalName: goalName,
        deadline: deadline,
        docID: docID,
        tasks: tasks,
        creationDate: creationDate,
        numOfTasks: numOfTasks,
        creatorId: creatorId,
        competitors: competitors,
        );
    setState(ViewState.Busy);
    var result = await _firstoreService.updateGoal(updatedGoal);
    setState(ViewState.Idle);
    if (eventId != null) {
      var dialogResponse = await _dialogService.showConfirmationDialog(
        title: 'your Goal was updated successfully!',
        description: 'Do you want to update your Google Calendar?',
        confirmationTitle: 'Yes',
        cancelTitle: 'No',
      );
      if (dialogResponse.confirmed) {
        setState(ViewState.Busy);
        googleCalendar.updateEvent(goalName, creationDate, deadline, eventId);
        _firstoreService.updateEventId(updatedGoal.docID);

        setState(ViewState.Idle);
      }
    } else {
      var dialogResponse = await _dialogService.showDialog(
        title: 'Success',
        description: 'your Goal was updated successfully!',
      );
    }
    return result;
  }
}

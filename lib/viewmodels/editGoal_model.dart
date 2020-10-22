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
      List<Task> tasks, String docID) async {
    Goal goal = Goal(
        goalName: goalName,
        deadline: deadline,
        docID: docID,
        tasks: tasks,
        creationDate: creationDate);
    setState(ViewState.Busy);
    var result = await _firstoreService.updateGoal(goal);
    setState(ViewState.Idle);

    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'your Goal was updated successfully!',
      description: 'Do you want to update your Google Calendar?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );
    if (dialogResponse.confirmed) {
      GoogleCalendar googleCalendar = new GoogleCalendar();
      setState(ViewState.Busy);
      googleCalendar.updateEvent(goalName, DateTime.now(), deadline, docID);
      setState(ViewState.Idle);
      return true;
    }

    return result;
  }
}

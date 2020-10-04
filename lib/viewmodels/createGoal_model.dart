import 'package:flutter/material.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/models/validationItem.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/models/goal.dart';
import 'package:peak/models/task.dart';

class CreateGoalModel extends ChangeNotifier {
  ValidationItem _goalName = ValidationItem(null, null);

  ViewState _state = ViewState.Idle;

  ValidationItem get goalName => _goalName;

  bool get isValid => goalName.value != null;

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

  Future createGoal(
      String goalName, String uID, DateTime deadLine, List<Task> tasks) async {
    Goal goal = Goal(
        goalName: goalName,
        uID: uID,
        deadline: deadLine,
        tasks: tasks,
        creationDate: DateTime.now());
    setState(ViewState.Busy);
    var result = await DatabaseServices().updateGoal(goal: goal);
    setState(ViewState.Idle);
    return result;
  }
}
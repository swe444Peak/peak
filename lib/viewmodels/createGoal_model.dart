import 'package:flutter/material.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/models/goal.dart';
import 'package:peak/models/task.dart';

class CreateGoalModel extends ChangeNotifier {
  ViewState _state = ViewState.Idle;

  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  Future createGoal(String goalName, String uID, DateTime deadLine,
      int numberOfTaksPerDay, List<Task> tasks) async {
    Goal goal = Goal(
        goalName: goalName,
        uID: uID,
        deadline: deadLine,
        numberOfTaksPerDay: numberOfTaksPerDay,
        tasks: tasks);
    setState(ViewState.Busy);
    var result = await DatabaseServices().updateGoal(goal: goal);
    setState(ViewState.Idle);
    return result;
  }
}

import 'package:flutter/material.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/models/validationItem.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/models/goal.dart';
import 'package:peak/models/task.dart';
import 'package:peak/services/googleCalendar.dart';
import 'package:random_string/random_string.dart';

import '../locator.dart';

class CreateGoalModel extends ChangeNotifier {
  ValidationItem _goalName = ValidationItem(null, null);
  ValidationItem _dueDate = ValidationItem(null, null);

  ViewState _state = ViewState.Idle;

  ValidationItem get goalName => _goalName;
  ValidationItem get dueDate => _dueDate;
    final googleCalendar = locator<GoogleCalendar>();

  bool get isValid => goalName.value != null && _dueDate.value != null;
 var result ;
  ViewState get state => _state;

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

  Future createGoal(
      String goalName, String uID, DateTime deadLine, List<Task> tasks) async {
    Goal goal = Goal(
        goalName: goalName,
        uID: uID,
        deadline: deadLine,
        tasks: tasks,
        creationDate: DateTime.now());
    setState(ViewState.Busy);
   
   result = await DatabaseServices().addGoal(goal: goal);
    setState(ViewState.Idle);
    return result;
  }

 Future addGoalToGoogleCalendar(
           String name, DateTime startDate, DateTime endDate) async {
    await googleCalendar.setEvent(name, startDate, endDate);
  }
  
  uPdateEventId(){
   _firebaceService.updateEventId(result.toString());
  
 }
  
}

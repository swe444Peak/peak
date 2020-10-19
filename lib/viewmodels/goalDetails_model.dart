import 'package:flutter/cupertino.dart';
import 'package:peak/models/goal.dart';
import 'package:peak/enums/taskType.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/models/task.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/services/dialogService.dart';

import '../locator.dart';

class GoalDetailsModel extends ChangeNotifier {
  DialogService _dialogService = locator<DialogService>();
  final _firstoreService = locator<DatabaseServices>();
  ViewState _state = ViewState.Idle;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  addGoalToGoogleCalendar() {}

  T task<T>(goal, index) {
    var currentTask;
    var currentTaskType = goal.tasks[index].taskType;
    if (currentTaskType == TaskType.monthly) {
      currentTask = goal.tasks[index] as MonthlyTask;
    } else if (currentTaskType == TaskType.once) {
      currentTask = goal.tasks[index] as OnceTask;
    } else if (currentTaskType == TaskType.weekly) {
      currentTask = goal.tasks[index] as WeeklyTask;
    } else if (currentTaskType == TaskType.daily) {
      currentTask = goal.tasks[index] as DailyTask;
    }
    return currentTask;
  }

  Future<bool> deleteGoal(Goal goal) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete the goal?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );
    if (dialogResponse.confirmed) {
      setState(ViewState.Busy);
      await _firstoreService.deleteGoal(goal.docID);
      setState(ViewState.Idle);
      return true;
    }
    return false;
  }
}

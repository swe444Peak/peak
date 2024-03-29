import 'package:flutter/cupertino.dart';
import 'package:peak/models/badges.dart';
import 'package:peak/models/goal.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/enums/taskType.dart';
import 'package:peak/locator.dart';
import 'package:peak/models/task.dart';
import 'package:peak/models/user.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/services/firebaseAuthService.dart';

class HomeModel extends ChangeNotifier {
  final _firstoreService = locator<DatabaseServices>();
  ViewState _state = ViewState.Idle;
  List<Goal> _goals;
  List<Map<String, dynamic>> _completedTasks = [],
      _incompletedTasks = [],
      _tasks = [];
  DateTime today = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  bool empty = true;
  List<Goal> get goals => _goals;
  ViewState get state => _state;
  PeakUser user;
  final _firebaseAuthService = locator<FirbaseAuthService>();
  List<Map<String, dynamic>> get compTasks => _completedTasks;
  List<Map<String, dynamic>> get incompTasks => _incompletedTasks;
  List<Map<String, dynamic>> get tasks => _tasks;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  void readTasks() {
    setState(ViewState.Busy);
    _firstoreService.getGoals(null).listen((goalData) {
      List<Goal> updatedGoals = goalData;
      if (updatedGoals != null) {
        if (updatedGoals.length > 0) {
          empty = false;
          _goals = updatedGoals;
          sortGoals();
        } else {
          empty = true;
        }
        //Tasks reading
        if (!empty) {
          _completedTasks = [];
          _incompletedTasks = [];
          _tasks = [];
          _goals.forEach((goal) {
            if (goal.deadline.compareTo(DateTime(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day)) >=
                0)
              goal.tasks.forEach((task) {
                var type = task.taskType.toShortString().toLowerCase();
                var currentTask;
                switch (type) {
                  case "once":
                    currentTask = task as OnceTask;
                    if (isAtSameDate(currentTask.date, today)) {
                      if (currentTask.done) {
                        _completedTasks.add({
                          "goal": goal.goalName,
                          "task": currentTask,
                          "status": true,
                          "goalId": goal.docID,
                          "type": type,
                        });
                      } else {
                        _incompletedTasks.add({
                          "goal": goal.goalName,
                          "task": currentTask,
                          "status": false,
                          "goalId": goal.docID,
                          "type": type,
                        });
                      }
                    }
                    break;
                  case "daily":
                    currentTask = task as DailyTask;
                    bool comp = false;
                    currentTask.doneDates.forEach((date) {
                      if (isAtSameDate(date, today)) {
                        comp = true;
                        _completedTasks.add({
                          "goal": goal.goalName,
                          "task": currentTask,
                          "status": true,
                          "goalId": goal.docID,
                          "type": type,
                        }); //end add
                      } //end if same
                    }); //end forEach
                    if (comp) break;
                    _incompletedTasks.add({
                      "goal": goal.goalName,
                      "task": currentTask,
                      "status": false,
                      "goalId": goal.docID,
                      "type": type,
                    });
                    break;
                  case "weekly":
                    currentTask = task as WeeklyTask;
                    bool comp = false;
                    currentTask.doneDates.forEach((date) {
                      if (isAtSameDate(date, today)) {
                        comp = true;
                        _completedTasks.add({
                          "goal": goal.goalName,
                          "task": currentTask,
                          "status": true,
                          "goalId": goal.docID,
                          "type": type,
                        }); //end add
                      } //end if same
                    }); //end forEach
                    if (comp) break;
                    currentTask.dates.forEach((date) {
                      if (isAtSameDate(date, today)) {
                        _incompletedTasks.add({
                          "goal": goal.goalName,
                          "task": currentTask,
                          "status": false,
                          "goalId": goal.docID,
                          "type": type,
                        }); //end add
                      } //end if same
                    }); //end forEach
                    break;
                  case "monthly":
                    currentTask = task as MonthlyTask;
                    bool comp = false;
                    currentTask.doneDates.forEach((date) {
                      if (isAtSameDate(date, today)) {
                        comp = true;
                        _completedTasks.add({
                          "goal": goal.goalName,
                          "task": currentTask,
                          "status": true,
                          "goalId": goal.docID,
                          "type": type,
                        }); //end add
                      } //end if same
                    }); //end forEach
                    if (comp) break;
                    currentTask.dates.forEach((date) {
                      if (isAtSameDate(date, today)) {
                        _incompletedTasks.add({
                          "goal": goal.goalName,
                          "task": currentTask,
                          "status": false,
                          "goalId": goal.docID,
                          "type": type,
                        }); //end add
                      } //end if same
                    }); //end forEach
                    break;
                } //end switch
              }); //end forEach task
          }); //end forEach goal
          compin();
        } //end if

        notifyListeners();
      }
      setState(ViewState.Idle);
    }, onError: (error) => print(error));
  }

  Future updateTask(Task task, String docId, bool status) async {
    var type = task.taskType.toShortString().toLowerCase();
    switch (type) {
      case "once":
        OnceTask currentTask = task as OnceTask;
        OnceTask newTask = new OnceTask(
            taskName: currentTask.taskName,
            date: currentTask.date,
            done: currentTask.done,
            taskRepetition: currentTask.taskRepetition,
            achievedTasks: currentTask.achievedTasks,
            creationDate: currentTask.creationDate);
        if (status) {
          // true => change state from done to not done
          newTask.done = false;
          newTask.achievedTasks--;
        } else {
          //false => chane state from not done to done
          newTask.done = true;
          newTask.achievedTasks++;
        }
        return await _firstoreService.updateTask(docId, currentTask, newTask);
      case "daily":
        DailyTask currentTask = task as DailyTask;
        DailyTask newTask = new DailyTask(
            taskName: currentTask.taskName,
            doneDates: new List<DateTime>.from(currentTask.doneDates),
            taskRepetition: currentTask.taskRepetition,
            achievedTasks: currentTask.achievedTasks,
            creationDate: currentTask.creationDate);
        if (status) {
          newTask.doneDates.remove(today);
          newTask.achievedTasks--;
        } else {
          newTask.doneDates.add(today);
          newTask.achievedTasks++;
        }
        return await _firstoreService.updateTask(docId, currentTask, newTask);
      case "weekly":
        WeeklyTask currentTask = task as WeeklyTask;
        WeeklyTask newTask = new WeeklyTask.withDates(
            taskName: currentTask.taskName,
            weekdays: new List<int>.from(currentTask.weekdays),
            doneDates: new List<DateTime>.from(currentTask.doneDates),
            taskRepetition: currentTask.taskRepetition,
            achievedTasks: currentTask.achievedTasks,
            dates: new List<DateTime>.from(currentTask.dates),
            creationDate: currentTask.creationDate);
        if (status) {
          newTask.doneDates.remove(today);
          newTask.achievedTasks--;
        } else {
          newTask.doneDates.add(today);
          newTask.achievedTasks++;
        }
        return await _firstoreService.updateTask(docId, currentTask, newTask);
      case "monthly":
        MonthlyTask currentTask = task as MonthlyTask;
        MonthlyTask newTask = new MonthlyTask.withDates(
            taskName: currentTask.taskName,
            day: currentTask.day,
            achievedTasks: currentTask.achievedTasks,
            taskRepetition: currentTask.taskRepetition,
            dates: new List<DateTime>.from(currentTask.dates),
            doneDates: new List<DateTime>.from(currentTask.doneDates),
            creationDate: currentTask.creationDate);
        if (status) {
          newTask.doneDates.remove(today);
          newTask.achievedTasks--;
        } else {
          newTask.doneDates.add(today);
          newTask.achievedTasks++;
        }
        return await _firstoreService.updateTask(docId, currentTask, newTask);
    } //end switch
  }

  void sortGoals() {
    _goals.sort((a, b) => a.creationDate.compareTo(b.creationDate));
    _goals = _goals.reversed.toList();
  }

  bool isAtSameDate(DateTime date1, DateTime date2) {
    if (date1.day == date2.day) {
      if (date1.month == date2.month) if (date1.year == date2.year) return true;
    } //end if
    return false;
  }

  void compin() {
    if (_incompletedTasks.isNotEmpty) {
      _incompletedTasks.forEach((element) {
        _tasks.add(element);
      });
    } //end if incom
    if (_completedTasks.isNotEmpty) {
      _completedTasks.forEach((element) {
        _tasks.add(element);
      });
    }
  }

  double clacToatlProgress() {
    double progress = 0.0;
    if (_goals != null && goals.length > 0) {
      _goals.forEach((element) {
        progress += element.calcProgress();
      });
      progress = (progress / goals.length) * 100;
    }

    return progress;
  }

  bool updateBadge(
    String name, {
    bool decrement = false,
  }) {
    if (name.compareTo("50% Total Progress") == 0 && clacToatlProgress() < 50) {
      return false;
    }
    user = _firebaseAuthService.currentUser;
    Badge oldBadge;
    user.badges.forEach((badge) {
      if (badge.name.compareTo(name) == 0) oldBadge = badge;
    });

    Badge newBadge = Badge(
      name: oldBadge.name,
      description: oldBadge.description,
      goal: oldBadge.goal,
      counter: oldBadge.counter,
      status: oldBadge.status,
      dates: List.from(oldBadge.dates),
    );
    bool update;
    if (decrement) {
      update = newBadge.updateStatus(increment: false);
    } else {
      update = newBadge.updateStatus();
    }
    if (update) {
      user.badges.remove(oldBadge);
      user.badges.add(newBadge);
      _firstoreService.updateBadge(oldBadge, newBadge);
      return newBadge.status;
    }
    return false;
  }
}

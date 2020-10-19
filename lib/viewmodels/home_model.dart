import 'package:flutter/cupertino.dart';
import 'package:peak/models/goal.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/enums/taskType.dart';
import 'package:peak/locator.dart';
import 'package:peak/models/task.dart';
import 'package:peak/models/user.dart';
import 'package:peak/services/databaseServices.dart';

class HomeModel extends ChangeNotifier {
  final _firstoreService = locator<DatabaseServices>();
  ViewState _state = ViewState.Idle;
  List<Goal> _goals;
  List<Map<String, dynamic>> _completedTasks, _incompletedTasks;
  DateTime today = DateTime.now();
  bool empty = true;
  List<Goal> get goals => _goals;
  ViewState get state => _state;
  List<Map<String, dynamic>> get compTasks => _completedTasks;
  List<Map<String, dynamic>> get incompTasks => _incompletedTasks;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  PeakUser getUser(){
    var user;
    _firstoreService.userData().listen((event) {
      user = event;
     });

     return user;
  }

  void readTasks(){
    setState(ViewState.Busy);
    readGoals();
    if(!empty){
      _goals.forEach((goal) { 
        goal.tasks.forEach((task) {
          var type = task.taskType.toShortString().toLowerCase();
          var currentTask;
          switch(type){
            case"once":
                        currentTask = task as OnceTask;
                        if(isAtSameDate(currentTask.date, today)){
                          if(currentTask.done){
                            _completedTasks.add({
                              "goal": goal.goalName,
                              "task": currentTask.taskName,
                            });
                          }else{
                            _incompletedTasks.add({
                              "goal": goal.goalName,
                              "task": currentTask.taskName,
                            });
                          }
                        }
                        break;
            case"daily":
                        currentTask = task as DailyTask;
                        bool comp = false;
                        currentTask.doneDates.forEach((date){
                          if(isAtSameDate(date, today)){
                            comp = true;
                            _completedTasks.add({
                              "goal": goal.goalName,
                              "task": currentTask.taskName,
                            });//end add
                          }//end if same
                        });//end forEach
                        if(comp)
                            break;
                          _incompletedTasks.add({
                              "goal": goal.goalName,
                              "task": currentTask.taskName,
                            });
                        break;
            case"weekly":
                        currentTask = task as WeeklyTask;
                        bool comp = false;
                        currentTask.doneDates.forEach((date){
                          if(isAtSameDate(date, today)){
                            comp = true;
                            _completedTasks.add({
                              "goal": goal.goalName,
                              "task": currentTask.taskName,
                            });//end add
                          }//end if same
                        });//end forEach
                        if(comp)
                            break;
                          currentTask.doneDates.forEach((date){
                          if(isAtSameDate(date, today)){
                            _completedTasks.add({
                              "goal": goal.goalName,
                              "task": currentTask.taskName,
                            });//end add
                          }//end if same
                        });//end forEach
                        break;
            case"monthly":
                        currentTask = task as MonthlyTask;
                        bool comp = false;
                        currentTask.doneDates.forEach((date){
                          if(isAtSameDate(date, today)){
                            comp = true;
                            _completedTasks.add({
                              "goal": goal.goalName,
                              "task": currentTask.taskName,
                            });//end add
                          }//end if same
                        });//end forEach
                        if(comp)
                            break;
                          currentTask.doneDates.forEach((date){
                          if(isAtSameDate(date, today)){
                            _completedTasks.add({
                              "goal": goal.goalName,
                              "task": currentTask.taskName,
                            });//end add
                          }//end if same
                        });//end forEach
                        break;
          }//end switch
         });//end forEach task
      });//end forEach goal
    }//end if
    setState(ViewState.Idle);
  }

  void readGoals() {
    setState(ViewState.Busy);
    _firstoreService.getGoals().listen((goalData) {
      List<Goal> updatedGoals = goalData;
      if (updatedGoals != null) {
        if (updatedGoals.length > 0) {
          empty = false;
          _goals = updatedGoals;
          sortGoals();
        } else {
          empty = true;
        }
        notifyListeners();
      }
      setState(ViewState.Idle);
    }, onError: (error) => print(error));
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

}

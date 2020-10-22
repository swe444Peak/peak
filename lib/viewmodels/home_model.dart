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
  List<Map<String, dynamic>> _completedTasks, _incompletedTasks , _tasks ;
  DateTime today = DateTime.now();
  bool empty = true;
  List<Goal> get goals => _goals;
  ViewState get state => _state;
  List<Map<String, dynamic>> get compTasks => _completedTasks;
  List<Map<String, dynamic>> get incompTasks => _incompletedTasks;
  List<Map<String, dynamic>> get tasks => _tasks;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }


  

  void readTasks() {
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
        //Tasks reading
        if(!empty){
          _completedTasks = [];
          _incompletedTasks =[];
          _tasks = [];
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
                              "task": currentTask,
                              "status": true,
                              "goalId": goal.docID,
                              "type": type,
                            });
                          }else{
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
            case"daily":
                        currentTask = task as DailyTask;
                        bool comp = false;
                        print("task name = ${currentTask.taskName},   array len= ${currentTask.doneDates.length}");
                        currentTask.doneDates.forEach((date){
                          if(isAtSameDate(date, today)){
                            print("task is done");
                            comp = true;
                            _completedTasks.add({
                              "goal": goal.goalName,
                              "task": currentTask,
                              "status": true,
                              "goalId": goal.docID,
                              "type": type,
                            });//end add
                          }//end if same
                        });//end forEach
                        if(comp)
                            break;
                          _incompletedTasks.add({
                              "goal": goal.goalName,
                              "task": currentTask,
                              "status": false,
                              "goalId": goal.docID,
                              "type": type,
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
                              "task": currentTask,
                              "status": true,
                              "goalId": goal.docID,
                              "type": type,
                            });//end add
                          }//end if same
                        });//end forEach
                        if(comp)
                            break;
                          currentTask.doneDates.forEach((date){
                          if(isAtSameDate(date, today)){
                            _incompletedTasks.add({
                              "goal": goal.goalName,
                              "task": currentTask,
                              "status": false,
                              "goalId": goal.docID,
                              "type": type,
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
                              "task": currentTask,
                              "status": true,
                              "goalId": goal.docID,
                              "type": type,
                            });//end add
                          }//end if same
                        });//end forEach
                        if(comp)
                            break;
                          currentTask.doneDates.forEach((date){
                          if(isAtSameDate(date, today)){
                            _incompletedTasks.add({
                              "goal": goal.goalName,
                              "task": currentTask,
                              "status": false,
                              "goalId": goal.docID,
                              "type": type,
                            });//end add
                          }//end if same
                        });//end forEach
                        break;
          }//end switch
         });//end forEach task
      });//end forEach goal
    }//end if
    compin();
        notifyListeners();
      }
      setState(ViewState.Idle);
    }, onError: (error) => print(error));
  }

  void updateTask (Task currentTask, String docId, bool status){
    print("inside updateTask()");
    var type = currentTask.taskType.toShortString().toLowerCase();
    if(status){  //true = uncheck the task
      switch(type){
            case"once":
                        OnceTask newTask = currentTask;
                        newTask.done = false;
                        _firstoreService.updateTask(docId, currentTask as OnceTask, newTask);
                        break;
            case"daily":
                        DailyTask newTask = currentTask;
                        newTask.doneDates.remove(today);
                        _firstoreService.updateTask(docId, currentTask as DailyTask, newTask);
                        break;
            case"weekly":
                        WeeklyTask newTask = currentTask;
                        newTask.doneDates.remove(today);
                        _firstoreService.updateTask(docId, currentTask as WeeklyTask, newTask);
                        break;
            case"monthly":
                        MonthlyTask newTask = currentTask;
                        newTask.doneDates.remove(today);
                        _firstoreService.updateTask(docId, currentTask as MonthlyTask, newTask);
                        break;
          }//end switch
    }else{  //false = the task is checked
      print("inside else before switch");
      print("type = $type");
      switch(type){
            case"once":
                        OnceTask newTask = currentTask;
                        newTask.done = true;
                        _firstoreService.updateTask(docId, currentTask, newTask);
                        break;
            case"daily":
                        print("inside switch daily");
                        DailyTask newTask = currentTask;
                        newTask.doneDates.add(today);
                        newTask.achievedTasks++;
                        _firstoreService.updateTask(docId, currentTask, newTask);
                        break;
            case"weekly":
                        WeeklyTask newTask = currentTask;
                        newTask.doneDates.add(today);
                        _firstoreService.updateTask(docId, currentTask, newTask);
                        break;
            case"monthly":
                        MonthlyTask newTask = currentTask;
                        newTask.doneDates.add(today);
                        _firstoreService.updateTask(docId, currentTask, newTask);
                        break;
          }//end switch
    }
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

  void compin(){
    if(_incompletedTasks.isNotEmpty){
      _incompletedTasks.forEach((element) {
        _tasks.add(element);
       });
    }//end if incom
    if(_completedTasks.isNotEmpty){
      _completedTasks.forEach((element) {
        _tasks.add(element);
      });
    }
  }



}

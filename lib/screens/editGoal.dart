import 'package:flutter/material.dart';
import 'package:peak/enums/taskType.dart';
import 'package:peak/models/goal.dart';
import 'package:peak/models/task.dart';
import 'package:peak/screens/shared/base.dart';
import 'package:peak/services/notification.dart';
import 'package:peak/viewmodels/editGoal_model.dart';
import 'package:provider/provider.dart';
import 'editTask.dart';

class EditGoal extends StatefulWidget {
  Goal goal;
  EditGoal({this.goal});
  @override
  _EditGoalState createState() => _EditGoalState();
}

class _EditGoalState extends State<EditGoal> {
  NotificationManager notifyManeger = new NotificationManager();
  String _error;
  TextEditingController _goalnamecontroller = TextEditingController();
  TextEditingController _dueDatecontroller = TextEditingController();
  DateTime _dateTime;
  List<Task> tasks = [];

  setError(value) => setState(() => _error = value);
  List<Task> tasksBeforeEdit = [];
  final GlobalKey<EditTaskState> editTaskState = GlobalKey<EditTaskState>();

  void initState() {
    widget.goal.tasks.forEach((element) {
      tasksBeforeEdit.add(element);
    });
    _goalnamecontroller.text = widget.goal.goalName;
    _dateTime = widget.goal.deadline;
    _dueDatecontroller.text =
        "${widget.goal.deadline.day}/${widget.goal.deadline.month}/${widget.goal.deadline.year}";
    tasks = widget.goal.tasks;
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider<EditGoalModel>(
      create: (context) => EditGoalModel(),
      child: Consumer<EditGoalModel>(
        builder: (context, model, child) => Base(
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  widget.goal.tasks = tasksBeforeEdit;
                });
                Navigator.pop(context);
              }),
          chidlPadding: EdgeInsets.fromLTRB(0, 0, 0, 0.0),
          title: "edit Goal",
          child: Column(
            children: [
              showAlert(),
              Container(
                padding: EdgeInsets.fromLTRB(
                    width * 0.06, 0.0, width * 0.06, height * 0.03),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: [
                    Card(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(width * 0.06),
                        child: TextField(
                          controller: _goalnamecontroller,
                          decoration: InputDecoration(
                            labelText: 'Goal Name',
                            errorText: model.goalName.error,
                          ),
                          style: TextStyle(
                            fontSize: width * 0.04,
                            color: Colors.grey[700],
                          ),
                          onChanged: (value) => model.setGoalName(value),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(width * 0.06),
                        child: TextField(
                          controller: _dueDatecontroller,
                          decoration: InputDecoration(
                            labelText: "Due Date",
                            errorText: model.dueDate.error,
                            icon: Icon(Icons.calendar_today),
                          ),
                          style: TextStyle(
                              fontSize: width * 0.04, color: Colors.grey[700]),
                          readOnly: true,
                          onTap: () {
                            setState(() {
                              _datePicker(context);
                              model.setDueDate(_dateTime.toString());
                            });
                          },
                        ),
                      ),
                    ),
                    EditTask(editTaskState, widget.goal.tasks, width, height,
                        setError, _dateTime),
                    RaisedButton(
                      splashColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      color: Colors.white,
                      onPressed: () {
                        bool valid = isValid();
                        if (valid && model.isValid) {
                          if (tasks.length > 0) {
                            model.updateGoal(
                              _goalnamecontroller.text,
                              widget.goal.creationDate,
                              _dateTime,
                              tasks,
                              widget.goal.docID,
                              widget.goal.eventId,
                            );
                            for (var item in tasks) {
                              switch (item.taskType.toShortString()) {
                                case 'once':
                                  OnceTask oTask = item as OnceTask;
                                  notifyManeger.showNotificationOnce(
                                      'Reminder To', item.taskName, oTask.date);
                                  print("Once");
                                  print(oTask.date);
                                  break;
                                case 'daily':
                                  print("Daily");
                                  notifyManeger.showDailyNotification(
                                      'Daily Reminder',
                                      item.taskName,
                                      _dateTime);

                                  break;
                                case 'weekly':
                                  WeeklyTask wTask = item as WeeklyTask;
                                  notifyManeger.showTaskNotification(
                                      'Weekly Reminder',
                                      item.taskName,
                                      wTask.dates);
                                  break;
                                case 'monthly':
                                  //add dates list
                                  MonthlyTask mTask = item as MonthlyTask;
                                  notifyManeger.showTaskNotification(
                                      'Monthly Reminder',
                                      item.taskName,
                                      mTask.dates);
                                  break;
                                default:
                                  print(
                                      'Somthing went WRONG in set notification');
                              }
                            }
                            Navigator.pushNamed(context, 'goalsList');

                            notifyManeger.showDeadlineNotification(
                                'Deadline Reminder',
                                'The deadline for ' +
                                    _goalnamecontroller.text +
                                    ' goal is Tomorrow',
                                _dateTime);
                          } else {
                            setState(() {
                              _error = "a goal should have at lest one task";
                            });
                          }
                        } else {
                          if (model.goalName.error == null &&
                              model.goalName.value == null) {
                            model.setGoalName("");
                          }
                          if (model.dueDate.error == null &&
                              model.dueDate.value == null) {
                            model.setDueDate("");
                          }
                          if (!valid) {
                            setState(() {
                              _error =
                                  "Oops, it looks like you have invalid tasks! try to edit or delete them";
                            });
                          }
                        }
                      },
                      textColor: Colors.black,
                      child:
                          Text('Edit Goal', style: TextStyle(fontSize: 19.0)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _datePicker(BuildContext context) async {
    DateTime _picker = await showDatePicker(
        context: context,
        initialDate: widget.goal.deadline,
        firstDate: DateTime.now(),
        lastDate: DateTime(2120));
    if (_picker != null) {
      setState(() {
        _dateTime = _picker;
        _dueDatecontroller.text = _dateTime.toString().split(' ').first;
        editTaskState.currentState.deadline = _dateTime;
        editTaskState.currentState.buildTasks(null);
      });
    }
  }

  bool isValid() {
    bool isValid = true;
    tasks.forEach((element) {
      var currentTask;
      var currentTaskType = element.taskType;
      if (currentTaskType == TaskType.monthly) {
        currentTask = element as MonthlyTask;
      } else if (currentTaskType == TaskType.once) {
        currentTask = element as OnceTask;
      } else if (currentTaskType == TaskType.weekly) {
        currentTask = element as WeeklyTask;
      } else if (currentTaskType == TaskType.daily) {
        currentTask = element as DailyTask;
      }
      if (currentTask.taskRepetition == 0) {
        isValid = false;
        return;
      }
    });
    return isValid;
  }

  Widget showAlert() {
    if (_error != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: Text(_error),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _error = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }
}

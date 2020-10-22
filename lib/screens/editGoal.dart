import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peak/enums/taskType.dart';
import 'package:peak/models/goal.dart';
import 'package:peak/models/task.dart';
import 'package:peak/services/googleCalendar.dart';
import 'package:peak/services/notification.dart';
import 'package:peak/viewmodels/editGoal_model.dart';
import 'package:provider/provider.dart';

<<<<<<< HEAD
import '../locator.dart';
import 'addTask.dart';
=======
import 'editTask.dart';
>>>>>>> 6bea6abe94e3507071985e822e25cfb1a6259500
//import 'editTask.dart';

class EditGoal extends StatefulWidget {
  Goal goal;
  EditGoal({this.goal});
  @override
  _EditGoalState createState() => _EditGoalState();
}

class _EditGoalState extends State<EditGoal> {
  var goalDocId;
  DateTime now = DateTime.now();
  GoogleCalendar googleCalendar = new GoogleCalendar();
  NotificationManager notifyManeger = new NotificationManager();
  String _error;
  TextEditingController _goalnamecontroller = TextEditingController();
  TextEditingController _dueDatecontroller = TextEditingController();
  DateTime _dateTime;
  List<Task> tasks = [];
  bool isEnabled = true;

  setError(value) => setState(() => _error = value);
  setEnabled(value) => setState(() => isEnabled = value);
  final GlobalKey<EditTaskState> editTaskState = GlobalKey<EditTaskState>();

  void initState() {
    _goalnamecontroller.text = widget.goal.goalName;
    _dateTime = widget.goal.deadline;

    _dueDatecontroller.text =
        "${widget.goal.deadline.day}/${widget.goal.deadline.month}/${widget.goal.deadline.year}";
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider<EditGoalModel>(
        create: (context) => EditGoalModel(),
        child: Consumer<EditGoalModel>(
            builder: (context, model, child) => Scaffold(
                  extendBodyBehindAppBar: true,
                  backgroundColor: Color.fromRGBO(23, 23, 85, 1.0),
                  appBar: AppBar(
                    title: Text(
                      "Edit a goal",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    bottom: PreferredSize(
                      preferredSize:
                          Size(MediaQuery.of(context).size.width, 50),
                      child: showAlert(),
                    ),
                  ),
                  body: Stack(
                    children: [
                      Container(
                        width: width * 0.8,
                        height: width * 0.6,
                        margin: EdgeInsets.fromLTRB(0, 0.0, width * 0.2, 0.0),
                        decoration: BoxDecoration(
                            color: Colors.indigo[500],
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(400)),
                            gradient: LinearGradient(
                                colors: [
                                  Colors.teal[400],
                                  Colors.indigo[600],
                                  Colors.deepPurple[900]
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomCenter)),
                      ),
                      SingleChildScrollView(
                        child: Container(
                          //height: height * 0.88,
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
                                    onChanged: (value) =>
                                        model.setGoalName(value),
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
                              EditTask(editTaskState, widget.goal.tasks, width,
                                  height, setError, _dateTime),
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
                                      goalDocId = model.createGoal(
                                          _goalnamecontroller.text,
                                          user?.uid,
                                          _dateTime,
                                          tasks);
                                      googleCalendar.updateEvent(
                                          _goalnamecontroller.text,
                                          now,
                                          _dateTime,
                                          goalDocId);
                                      for (var item in tasks) {
                                        switch (item.taskType.toShortString()) {
                                          case 'once':
                                            OnceTask oTask = item as OnceTask;
                                            notifyManeger.showNotificationOnce(
                                                'Reminder To',
                                                item.taskName,
                                                oTask.date);
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
                                            WeeklyTask wTask =
                                                item as WeeklyTask;
                                            notifyManeger.showTaskNotification(
                                                'Weekly Reminder',
                                                item.taskName,
                                                wTask.dates);
                                            break;
                                          case 'monthly':
                                            //add dates list
                                            MonthlyTask mTask =
                                                item as MonthlyTask;
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
                                      //confirm message here
                                      goalChangeDailog(context);
                                      notifyManeger.showDeadlineNotification(
                                          'Deadline Reminder',
                                          'The deadline for ' +
                                              _goalnamecontroller.text +
                                              ' goal is Tomorrow',
                                          _dateTime);
                                    } else {
                                      setState(() {
                                        _error =
                                            "a goal should have at lest one task";
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
                                child: Text('Edit Goal',
                                    style: TextStyle(fontSize: 19.0)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )));
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

  goalChangeDailog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        //Google calender here
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      scrollable: true,
      contentPadding: EdgeInsets.all(5),
      title: Text("Added Successfully !"),
      content: Column(
        children: [
          Text(
              "your goal was added successfully , would you like to add it to google calendar?"),
        ],
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
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
      if (currentTask.calcRepetition(_dateTime, DateTime.now()) == 0) {
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

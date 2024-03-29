import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:peak/models/task.dart';
import 'package:peak/models/user.dart';
import 'package:peak/enums/taskType.dart';
import 'package:peak/screens/addCompetitors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/services/googleCalendar.dart';
import 'package:peak/viewmodels/createGoal_model.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

import '../locator.dart';
import '../services/notification.dart';
import 'addTask.dart';

class NewGoal extends StatefulWidget {
  @override
  _NewGoalState createState() => _NewGoalState();
}

class _NewGoalState extends State<NewGoal> {
  var docId;
  String eventId;
  final googleCalendar = locator<GoogleCalendar>();

  var goalsCounter = 0;
  NotificationManager notifyManeger = NotificationManager();
  DateTime now = DateTime.now();
  String _error;
  TextEditingController _goalnamecontroller = TextEditingController();
  TextEditingController _dueDatecontroller = TextEditingController();
  DateTime _dateTime;
  String compititors = "Add Competitors";
  GlobalKey<AddCompetitorsState> addCompetitorsState =
      GlobalKey<AddCompetitorsState>();
  List<Task> tasks = [];
  List<PeakUser> addedFriends = [];
  bool isEnabled = true;
  setError(value) => setState(() => _error = value);
  setEnabled(value) => setState(() => isEnabled = value);
  GlobalKey<AddTaskState> addTaskState = GlobalKey<AddTaskState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _goalnamecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return Provider(
      create: (context) => tasks,
      child: StreamProvider<PeakUser>.value(
          initialData: PeakUser(uid: "", name: ""),
          value: DatabaseServices().userData(user.uid),
          builder: (context, snapshot) {
            return ChangeNotifierProvider<CreateGoalModel>(
              create: (context) => locator<CreateGoalModel>(),
              child: Consumer<CreateGoalModel>(
                builder: (context, model, child) => SafeArea(
                  child: Scaffold(
                    backgroundColor: Color.fromRGBO(23, 23, 85, 1.0),
                    extendBodyBehindAppBar: true,
                    appBar: AppBar(
                      title: Text(
                        "Add A New Goal",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      // bottom: PreferredSize(
                      //   preferredSize:
                      //       Size(MediaQuery.of(context).size.width, 50),
                      //   child: showAlert(),
                      // ),
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
                        Container(
                          height: height * 0.88,
                          margin: EdgeInsets.only(top: height * 0.1),
                          padding: EdgeInsets.fromLTRB(
                              width * 0.06, 0.0, width * 0.06, height * 0.01),
                          child: Scrollbar(
                            //isAlwaysShown: true,
                            controller: _scrollController,
                            child: ListView(
                              controller: _scrollController,
                              padding: EdgeInsets.only(right: width*0.03),
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
                                        labelStyle: TextStyle(
                                            fontSize: width * 0.04,
                                            color: Colors.grey[700]),
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
                                        labelStyle: TextStyle(
                                            fontSize: width * 0.04,
                                            color: Colors.grey[700]),
                                        errorText: model.dueDate.error,
                                        icon: Icon(Icons.calendar_today),
                                      ),
                                      readOnly: true,
                                      onTap: () {
                                        setState(() {
                                          _datePicker(context);
                                          model
                                              .setDueDate(_dateTime.toString());
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        width * 0.04,
                                        width * 0.02,
                                        width * 0.02,
                                        width * 0.02),
                                    child: ListTile(
                                      trailing: IconButton(
                                          icon: Icon(Icons.keyboard_arrow_right,
                                              color: Colors.indigo[900]),
                                          onPressed: () async {
                                            var comp;
                                            try {
                                              comp = await Navigator.pushNamed(
                                                  context, 'addCompetitors',
                                                  arguments: addedFriends);
                                            } catch (e) {
                                              print("diposed");
                                            }
                                            setState(() {
                                              if (comp != 0)
                                                compititors =
                                                    "$comp Competitors Are Added";
                                              else {
                                                compititors = "Add Competitors";
                                                addedFriends = [];
                                              }
                                            });
                                          }),
                                      title: Text(compititors,
                                          style: TextStyle(
                                              fontSize: width * 0.045,
                                              color: Colors.indigo[900])),
                                    ),
                                  ),
                                ),
                                AddTask(addTaskState, tasks, width, height,
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
                                        docId = model.createGoal(
                                            _goalnamecontroller.text,
                                            user?.uid,
                                            _dateTime,
                                            tasks,
                                            addedFriends);

                                        for (var item in tasks) {
                                          switch (
                                              item.taskType.toShortString()) {
                                            case 'once':
                                              OnceTask oTask = item as OnceTask;
                                              notifyManeger
                                                  .showNotificationOnce(
                                                      'Reminder To',
                                                      item.taskName,
                                                      oTask.date);
                                              print("Once");
                                              print(oTask.date);
                                              break;
                                            case 'daily':
                                              print("Daily");
                                              notifyManeger
                                                  .showDailyNotification(
                                                      'Daily Reminder',
                                                      item.taskName,
                                                      _dateTime);

                                              break;
                                            case 'weekly':
                                              WeeklyTask wTask =
                                                  item as WeeklyTask;
                                              notifyManeger
                                                  .showTaskNotification(
                                                      'Weekly Reminder',
                                                      item.taskName,
                                                      wTask.dates);
                                              break;
                                            case 'monthly':
                                              //add dates list
                                              MonthlyTask mTask =
                                                  item as MonthlyTask;
                                              notifyManeger
                                                  .showTaskNotification(
                                                      'Monthly Reminder',
                                                      item.taskName,
                                                      mTask.dates);
                                              break;
                                            default:
                                              print(
                                                  'Somthing went WRONG in set notification');
                                          }
                                        }
                                        Navigator.pushNamed(
                                            context, 'goalsList');
                                        //confirm message here
                                        goalConfirmDailog(model);
                                        bool badge = model.updateBadge();
                                        if (badge) {
                                          showDialog(
                                            context: context,
                                            useRootNavigator: false,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                scrollable: true,
                                                contentPadding:
                                                    EdgeInsets.all(50),
                                                title: Text(
                                                    "Wow you won new badge !"),
                                                content: Column(
                                                  children: [
                                                    Image.asset(
                                                      "assets/badges/first_goal_colored.png",
                                                      width: width * 0.5,
                                                    ),
                                                    Text(
                                                        "You won the First goal badge, go check it out in your profile !"),
                                                  ],
                                                ),
                                                actions: [
                                                  FlatButton(
                                                    child: Text("Ok"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        } //end if
                                        notifyManeger.showDeadlineNotification(
                                            'Deadline Reminder',
                                            'The deadline for ' +
                                                _goalnamecontroller.text +
                                                ' goal is Tomorrow',
                                            _dateTime);
                                      } else {
                                          _error =
                                              "a goal should have at lest one task";
                                          showColoredToast(_error);
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
                                          _error =
                                              "Oops, it looks like you have invalid tasks! try to edit or delete them";
                                          showColoredToast(_error);
                                      }
                                    }
                                  },
                                  textColor: Colors.black,
                                  child: Text('Add Goal',
                                      style: TextStyle(fontSize: 19.0)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
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

  Future _datePicker(BuildContext context) async {
    DateTime _picker = await showDatePicker(
        context: context,
        initialDate: _dateTime == null ? DateTime.now() : _dateTime,
        firstDate: DateTime.now(),
        lastDate: DateTime(2120));
    if (_picker != null) {
      setState(() {
        print(_picker);
        _dateTime = _picker;
        _dueDatecontroller.text = _dateTime.toString().split(' ').first;
        addTaskState.currentState.deadline = _dateTime;
        addTaskState.currentState.isDatePicked = true;
        addTaskState.currentState.buildTasks(null);
      });
    }
  }

  goalConfirmDailog(CreateGoalModel model) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () async {
        await model.addGoalToGoogleCalendar(
            _goalnamecontroller.text, now, _dateTime);
        print("after google calendar adding");
        model.uPdateEventId();
        Navigator.pop(context);
      },
    );
    showDialog(
      context: context,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          contentPadding: EdgeInsets.all(5),
          title: Text("Added Successfully !"),
          content: Column(
            children: [
              Lottie.asset('assets/goalConfirm.json', width: 200, height: 200),
              Text(
                  "your goal was added successfully , would you like to add it to google calendar?"),
            ],
          ),
          actions: [
            cancelButton,
            continueButton,
          ],
        );
      },
    );
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

  void showColoredToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.amberAccent[400],
        textColor: Colors.white);
  }
}

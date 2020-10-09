import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peak/models/task.dart';
import 'package:peak/models/user.dart';

import 'package:peak/services/databaseServices.dart';
import 'package:peak/viewmodels/createGoal_model.dart';
import 'package:provider/provider.dart';

import '../locator.dart';
import '../services/notification.dart';
import 'addTask.dart';

class NewGoal extends StatefulWidget {
  @override
  _NewGoalState createState() => _NewGoalState();
}

class _NewGoalState extends State<NewGoal> {
  var goalsCounter = 0;
  NotificationManager notifyManeger = new NotificationManager();
  String _error;
  TextEditingController _goalnamecontroller = TextEditingController();
  TextEditingController _dueDatecontroller = TextEditingController();
  DateTime _dateTime;
  List<Task> tasks = [];
  setError(value) => setState(() => _error = value);

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
                                          model
                                              .setDueDate(_dateTime.toString());
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                AddTask(tasks, width, height, setError),
                                RaisedButton(
                                  splashColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  color: Colors.white,
                                  onPressed: () {
                                    if (model.isValid) {
                                      if (tasks.length > 0) {
                                        model.createGoal(
                                            _goalnamecontroller.text,
                                            user?.uid,
                                            _dateTime,
                                            tasks);
                                        Navigator.pushNamed(
                                            context, 'goalsList');
                                        notifyManeger.showDeadlineNotification(
                                            'Deadline Reminder',
                                            'The deadline for' +
                                                _goalnamecontroller.text +
                                                'goal is Tomorrow',
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

  Future _datePicker(BuildContext context) async {
    DateTime _picker = await showDatePicker(
        context: context,
        initialDate: _dateTime == null ? DateTime.now() : _dateTime,
        firstDate: DateTime.now(),
        lastDate: DateTime(2120));
    if (_picker != null) {
      setState(() {
        _dateTime = _picker;
        _dueDatecontroller.text = _dateTime.toString().split(' ').first;
      });
    }
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

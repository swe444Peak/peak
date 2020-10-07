import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peak/models/user.dart';
import 'package:peak/screens/shared/commonStyle.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/viewmodels/createGoal_model.dart';
import 'package:provider/provider.dart';
import 'package:weekday_selector/weekday_selector.dart';
import '../services/notification.dart';
import 'goalConfirmation.dart';

class NewTaskPage extends StatefulWidget {
  @override
  _NewTaskPageState createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  var taskCounter = 0;
  NotificationManager notifyManeger = new NotificationManager();
  TextEditingController _taskcontroller = TextEditingController();
  String dropdownValue;
  String currentValue;
  int lastTapped;
  final values = [true, false, false, false, false, false, false];
  DateTime _dateTime;
  DateTime now = DateTime.now();
  /*
  printIntAsDay(int day) {
    print(
        'Received integer: $day. Corresponds to day: ${intDayToEnglish(day)}');
  }

  String intDayToEnglish(int day) {
    if (day % 7 == DateTime.monday % 7) return 'Monday';
    if (day % 7 == DateTime.tuesday % 7) return 'Tueday';
    if (day % 7 == DateTime.wednesday % 7) return 'Wednesday';
    if (day % 7 == DateTime.thursday % 7) return 'Thursday';
    if (day % 7 == DateTime.friday % 7) return 'Friday';
    if (day % 7 == DateTime.saturday % 7) return 'Saturday';
    if (day % 7 == DateTime.sunday % 7) return 'Sunday';
    throw '🐞 This should never have happened: $day';
  }
*/
  bool onlyOneDay(List<bool> values) {
    int counter = 0;
    for (int i = 0; i < values.length; i++) {
      if (values[i] == true) counter++;
    }
    if (counter == 1) {
      return true;
    }
    return false;
  }

  Widget repeatDate() {
    if (currentValue == "Daily") {
      return Text("*This task will repeat daily",
          style: TextStyle(
              fontFamily: 'Montserrat', fontSize: 18.0, color: Colors.teal),
          textAlign: TextAlign.center);
    } else if (currentValue == "Weekly") {
      return Column(
        children: [
          Text("*This task will repeat weekly on the days you pick",
              style: TextStyle(
                  fontFamily: 'Montserrat', fontSize: 18.0, color: Colors.teal),
              textAlign: TextAlign.center),
          WeekdaySelector(
            selectedFillColor: Colors.lightBlue[600],
            onChanged: (v) {
              //printIntAsDay(v);
              setState(() {
                if (onlyOneDay(values) && values[v % 7] == true) {
                } else {
                  values[v % 7] = !values[v % 7];
                }
              });
            },
            values: values,
          )
        ],
      );
    } else if (currentValue == "Monthly") {
      return Column(
        children: [
          Text("*Pick the starting day for your monthly task",
              style: TextStyle(
                  fontFamily: 'Montserrat', fontSize: 18.0, color: Colors.teal),
              textAlign: TextAlign.center),
          CalendarDatePicker(
              initialDate: _dateTime == null ? DateTime.now() : _dateTime,
              firstDate: DateTime.now(),
              lastDate: now.add(new Duration(days: 30)),
              onDateChanged: (d) {
                _dateTime = d;
              })
        ],
      );
    } else if (currentValue == "Once") {
      return Column(children: [
        Text("*Pick the starting day for your monthly task",
            style: TextStyle(
                fontFamily: 'Montserrat', fontSize: 18.0, color: Colors.teal),
            textAlign: TextAlign.center),
        CalendarDatePicker(
            initialDate: _dateTime == null ? DateTime.now() : _dateTime,
            firstDate: DateTime.now(),
            lastDate: DateTime(2120),
            onDateChanged: (d) {
              _dateTime = d;
            }),
      ]);
    }
    return SizedBox(
      height: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    CreateGoalModel model = CreateGoalModel();
    Size size = MediaQuery.of(context).size;
    var user = Provider.of<User>(context);
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return StreamProvider<PeakUser>.value(
        initialData: PeakUser(uid: "", name: ""),
        value: DatabaseServices().userData(user.uid),
        builder: (context, snapshot) {
          return Scaffold(
              backgroundColor: Color.fromRGBO(23, 23, 85, 1.0),
              body: SingleChildScrollView(
                child: Stack(children: [
                  Container(
                    width: width * 0.8,
                    height: width * 0.6,
                    margin: EdgeInsets.fromLTRB(width * 0.2, 0.0, 0.0, 0.0),
                    decoration: BoxDecoration(
                        color: Colors.indigo[500],
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(400)),
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
                    padding: EdgeInsets.fromLTRB(
                        width * 0.06, height * 0.12, width * 0.06, 0.0),
                    child: Column(children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                0.0, 0.0, 0.0, (width * 0.06)),
                            child: Text(
                              "Add A New Task",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: size.height * 0.06),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Task name :",
                                    style: TextStyle(
                                      color: Color.fromRGBO(23, 23, 85, 1.0),
                                      fontSize: 25,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 25),
                                specialTextField(
                                    _taskcontroller,
                                    false,
                                    "Task name",
                                    model.goalName.error,
                                    model.setGoalName), //change
                                SizedBox(height: 25),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Task type :",
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(23, 23, 85, 1.0),
                                          fontSize: 25,
                                        ),
                                      ),
                                      DropdownButton(
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(23, 23, 85, 1.0),
                                            fontSize: 25),
                                        value: dropdownValue,
                                        onChanged: (newValue) {
                                          setState(() {
                                            dropdownValue = newValue;
                                            currentValue = newValue;
                                          });
                                        },
                                        items: [
                                          'Daily',
                                          'Weekly',
                                          'Monthly',
                                          'Once'
                                        ].map<DropdownMenuItem<String>>(
                                            (value) {
                                          //currentValue = value;
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ]),
                                SizedBox(height: 20),
                                repeatDate(),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ButtonTheme(
                                      minWidth: 100.0,
                                      height: 50.0,
                                      child: RaisedButton(
                                        splashColor: Colors.teal,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                        color: Color.fromRGBO(23, 23, 85, 1.0),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      new GoalConfirmationPage()));
                                        },
                                        textColor: Colors.white,
                                        child: Text('Done',
                                            style: TextStyle(fontSize: 19.0)),
                                      ),
                                    ),
                                    ButtonTheme(
                                      minWidth: 100.0,
                                      height: 50.0,
                                      child: RaisedButton(
                                        splashColor: Colors.teal,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                        color: Color.fromRGBO(23, 23, 85, 1.0),
                                        onPressed: () {
                                        if(currentValue == 'Once')
                                        notifyManeger.showNotificationOnce( 'Remember To ',
                                              _taskcontroller.text,_dateTime);
                                           else
                                          notifyManeger.showTaskNotification(
                                              'Remember To ',
                                              _taskcontroller.text,
                                              dropdownValue);


                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      new NewTaskPage()));
                                        }, // sucess message
                                        textColor: Colors.white,
                                        child: Text('Add task',
                                            style: TextStyle(fontSize: 19.0)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ])
                    ]),
                  ),
                ]),
              ));
        });
  }

  // ignore: must_call_super
  void initState() {
    dropdownValue = 'Daily';
  }
}

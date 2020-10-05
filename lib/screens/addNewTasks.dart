import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peak/models/user.dart';
import 'package:peak/screens/addNewGoal.dart';
import 'package:peak/screens/profile.dart';
import 'package:peak/screens/shared/commonStyle.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/viewmodels/createGoal_model.dart';
import 'package:provider/provider.dart';

import '../services/notification.dart';

class NewTaskPage extends StatefulWidget {
  @override
  _NewTaskPageState createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  var taskCounter = 0;
  NotificationManager notifyManeger = new NotificationManager();
  TextEditingController _taskcontroller = TextEditingController();
  int _count = 1;
  String dropdownValue;
  String currentValue;
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
                                          });
                                        },
                                        items: [
                                          'Daily',
                                          'Weekly',
                                          'Monthly',
                                          'Once'
                                        ].map<DropdownMenuItem<String>>(
                                            (value) {
                                          currentValue = value;
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ]),
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
                                                      new ProfilePage()));
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

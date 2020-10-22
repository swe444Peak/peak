import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peak/services/notification.dart';
import 'package:peak/viewmodels/settings_model.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:peak/enums/taskType.dart';
import 'package:provider/provider.dart';
import '../models/goal.dart';
import '../models/task.dart';
import '../models/user.dart';
import '../services/databaseServices.dart';
import 'addGoal.dart';

class SettingsPage extends StatelessWidget {
  final DatabaseServices dBS = new DatabaseServices();
  final NotificationManager notifyManeger = new NotificationManager();
  final userRef = FirebaseFirestore.instance.collection('goals').get();

  //List<Task> _taskList = [];
  // UnmodifiableListView<Task> get taskList => UnmodifiableListView(_taskList);

  List<Goal> _goalList = [];
  UnmodifiableListView<Goal> get goalList => UnmodifiableListView(_goalList);

  // List<OnceTask> _otaskList = [];
  // UnmodifiableListView<Task> get otaskList => UnmodifiableListView(_otaskList);
  //List<DailyTask> _dtaskList = [];
  // UnmodifiableListView<Task> get dtaskList => UnmodifiableListView(_dtaskList);
  // List<WeeklyTask> _wtaskList = [];
  //UnmodifiableListView<Task> get wtaskList => UnmodifiableListView(_wtaskList);
  //List<MonthlyTask> _mtaskList = [];
  // UnmodifiableListView<Task> get mtaskList => UnmodifiableListView(_mtaskList);

  @override
  Widget build(BuildContext context) {
    // final QuerySnapshot listTas = userRef.
    var userId = Provider.of<User>(context);
    //var userp = Provider.of<PeakUser>(context);
    //  PeakUser user = new PeakUser(uid: "", name: "", notificationStatus: true);
    bool _state = true;
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    return StreamProvider<PeakUser>.value(
        initialData: PeakUser(uid: "", name: ""),
        value: DatabaseServices().userData(userId?.uid),
        builder: (context, snapshot) {
          return Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Color.fromRGBO(23, 23, 85, 1.0),
              appBar: AppBar(
                /*title: Text("Settings",
        style: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w400,
        ),),*/
                //centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
              body: SingleChildScrollView(
                child: Stack(
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
                      padding: EdgeInsets.fromLTRB(
                          width * 0.06, height * 0.12, width * 0.06, 0.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    0.0, 0.0, 0.0, (width * 0.06)),
                                child: Text(
                                  "Settings",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 34.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            //Account
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                            child: Card(
                              //card Property
                              //color: Colors.deepPurple[900],
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),

                              child: ListTile(
                                  leading: Icon(
                                    Icons.perm_identity,
                                    color: Color.fromRGBO(23, 23, 85, 1.0),
                                    size: 32,
                                  ),
                                  title: Text(
                                    "Edit Profile",
                                    style: TextStyle(
                                      color: Color.fromRGBO(23, 23, 85, 1.0),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(context, 'editProfile');
                                  }),
                            ),
                          ),
                          /*Padding(
                            //Account
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                            child: Card(
                              //card Property
                              //color: Colors.deepPurple[900],
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),

                              child: ListTile(
                                leading: Icon(
                                  Icons.perm_identity,
                                  color: Color.fromRGBO(23, 23, 85, 1.0),
                                  size: 32,
                                ),
                                title: Text(
                                  "Account",
                                  style: TextStyle(
                                    color: Color.fromRGBO(23, 23, 85, 1.0),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context, 'editAccount',
                                      arguments: userId);
                                },
                              ),
                            ),
                          ),*/
                          Padding(
                            //Logout
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                            child: Card(
                              //card Property
                              //color: Colors.deepPurple[900],
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),

                              child: ListTile(
                                leading: Icon(
                                  Icons.power_settings_new,
                                  color: Color.fromRGBO(23, 23, 85, 1.0),
                                  size: 32,
                                ),
                                title: Text(
                                  "Logout",
                                  style: TextStyle(
                                    color: Color.fromRGBO(23, 23, 85, 1.0),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                                onTap:
                                    //    *** TO DO: ADD THE LOGOUT FUNCTION HERE  ***

                                    () async {
                                  var success = await SettingsModel().logout();
                                  Navigator.pushNamed(context, 'login');
                                },
                              ),
                            ),
                          ),
                          ///////////SETTING
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                            child: Card(
                              //card Property
                              //color: Colors.deepPurple[900],
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),

                              /*child: ListTile(
                                leading: Text(
                                  "Notification         ",
                                  style: TextStyle(
                                    color: Color.fromRGBO(23, 23, 85, 1.0),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                                trailing: LiteRollingSwitch(
                                    textSize: 14,
                                    textOn: 'ON',
                                    textOff: 'OFF',
                                    colorOn: Colors.greenAccent,
                                    colorOff: Colors.redAccent,
                                    iconOn: Icons.done,
                                    iconOff: Icons.alarm_off,
                                    value: Provider.of<PeakUser>(context)
                                        .notificationStatus,
                                    onChanged: (state) {
                                      dBS.updateNotificationStatus(
                                          status: state);
                                      _state = state;
                                      if (state == false)
                                        notifyManeger.removeReminder();
                                      else if (state == true)
                                        for (var goal in _goalList) {
                                          if (!goal.isAchieved)
                                            notifyManeger
                                                .showDeadlineNotification(
                                                    "Deadline Reminder",
                                                    'The deadline for' +
                                                        goal.goalName +
                                                        'goal is Tomorrow',
                                                    goal.deadline);
                                          for (var item in goal.tasks) {
                                            switch (
                                                item.taskType.toShortString()) {
                                              case 'once':
                                                OnceTask oTask =
                                                    item as OnceTask;
                                                notifyManeger
                                                    .showNotificationOnce(
                                                        'Reminder To',
                                                        item.taskName,
                                                        oTask.date);
                                                print(oTask.date);
                                                break;
                                              case 'daily':
                                                notifyManeger
                                                    .showDailyNotification(
                                                        'Daily Reminder',
                                                        item.taskName,
                                                        notifyManeger
                                                            .goalDeadline);
                                                break;
                                              case 'weekly':
                                                WeeklyTask wTask =
                                                    item as WeeklyTask;
                                                notifyManeger
                                                    .showTaskNotification(
                                                        'Weekly Reminder',
                                                        item.taskName,
                                                        wTask.dates);
                                                print(wTask.dates);
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
                                                print(mTask.dates);
                                                break;
                                              default:
                                                print(
                                                    'Somthing went WRONG in set notification');
                                            }
                                          }
                                        }
                                      print("");
                                    }),
                                onTap: () {},
                              ),*/
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
}

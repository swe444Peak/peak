import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:peak/models/task.dart';

class Goal {
  String goalName;
  String uID;
  DateTime deadline;
  String docID;
  List<Task> tasks;
  bool isAchieved;
  DateTime creationDate;
  int numOfTasks;
  int achievedTasks;

  Goal({@required String goalName, @required String uID, @required DateTime deadline, String docID, List<Task>tasks,
  bool isAchieved: false, DateTime creationDate, int numOfTasks=0}){

    this.goalName = goalName;
    this.uID = uID;
    this.deadline = DateTime(deadline.year, deadline.month, deadline.day);
    this.docID = docID;
    this.tasks = tasks;
    this.isAchieved = checkAchieved();
    this.creationDate = DateTime(creationDate.year, creationDate.month, creationDate.day);
    this.numOfTasks = (numOfTasks==0? clacTasks() : numOfTasks);
  }

  Map<String, dynamic> toMap() {
    return {
      "goalName": this.goalName,
      "uID": this.uID,
      "deadLine": Timestamp.fromMicrosecondsSinceEpoch(
          this.deadline.microsecondsSinceEpoch),
      "tasks": this.mapfy(),
      "isAchieved": (this.isAchieved ? true : this.checkAchieved()),
      "creationDate": this.creationDate,
    };
  }

  List<Map<String, dynamic>> mapfy() {
    List<Map<String, dynamic>> mapfiedTasks = List<Map<String, dynamic>>();
    this.tasks.forEach((element) {
      mapfiedTasks.add(element.toMap());
    });
    return mapfiedTasks;
  }

  bool checkAchieved() {      //Rewirte
    this.tasks.forEach((element) {
      if (!element.done) return false; //not all tasks are achived
    }); //end forEach
    return true; //all tasks are achived
  } // end checkAchieved()

  double calcProgress() {       //Rewrite 
    int totalTasks = this.tasks.length;
    double achivedTasks = 0.0;
    this.tasks.forEach((element) {
      if (element.done) achivedTasks++;
    });
    return (achivedTasks/totalTasks) ;
  } //end calcProgress()

  static Task getTask(var element) {
    final type = element['taskType'];
    if (type == "daily") {
      return DailyTask.fromJson(element);
    }
    if (type == "once") {
      return OnceTask.fromJson(element);
    }
    if (type == "weekly") {
      return WeeklyTask.fromJson(element);
    }
    if (type == "monthly") {
      return MonthlyTask.fromJson(element);
    }
    return null;
  }

  static Goal fromJson(Map<String, dynamic> map, String docID) {
    if (map == null || map['tasks'] == null) {
      return null;
    }
    List<dynamic> taskList = map['tasks'];
    List<Task> newList = List<Task>();
    taskList.forEach((element) {
      var task = getTask(element);
      newList.add(task);
    });
    return Goal(
        goalName: map['goalName'],
        uID: map['uID'],
        deadline: map['deadLine'].toDate(),
        tasks: newList,
        docID: docID,
        isAchieved: map["isAchieved"],
        creationDate: map['creationDate'].toDate());
  }

  int clacTasks(){
    int totalTasks = 0;
    this.tasks.forEach((element) {
      totalTasks += element.calcRepetition(deadline, creationDate);
     });  //end forEach
    return totalTasks;
  }
}
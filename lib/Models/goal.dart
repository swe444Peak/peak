import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:peak/models/task.dart';
import 'package:random_string/random_string.dart';

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
  String eventId;
  Goal(
      {@required String goalName,
      String uID,
      @required DateTime deadline,
      String docID,
      List<Task> tasks,
      bool isAchieved = false,
      DateTime creationDate,
      int numOfTasks = 0, String eventId }) {
    this.goalName = goalName;
    this.uID = uID;
    this.deadline = DateTime(deadline.year, deadline.month, deadline.day);
    this.docID = docID;
    this.tasks = tasks;
    this.creationDate =
        DateTime(creationDate.year, creationDate.month, creationDate.day);
    this.numOfTasks = (numOfTasks == 0 ? clacTasks() : numOfTasks);
    this.isAchieved = (isAchieved ? isAchieved : checkAchieved());
    this.eventId=eventId;
  }

  Map<String, dynamic> toMap() {
    return {
      "goalName": this.goalName,
      "uID": this.uID,
      "deadline": Timestamp.fromMicrosecondsSinceEpoch(
          this.deadline.microsecondsSinceEpoch),
      "tasks": this.mapfy(),
      "isAchieved": (this.isAchieved ? true : this.checkAchieved()),
      "creationDate": this.creationDate,
      "numOfTasks": this.numOfTasks,
       "eventId":this.eventId,
    };
  }

  Map<String, dynamic> updateToMap() {
    return {
      "goalName": this.goalName,
      "deadline": Timestamp.fromMicrosecondsSinceEpoch(
          this.deadline.microsecondsSinceEpoch),
      "tasks": this.mapfy(),
      "isAchieved": (this.isAchieved ? true : this.checkAchieved()),
      "numOfTasks": this.numOfTasks,
    };
  }

  List<Map<String, dynamic>> mapfy() {
    List<Map<String, dynamic>> mapfiedTasks = List<Map<String, dynamic>>();
    this.tasks.forEach((element) {
      mapfiedTasks.add(element.toMap());
    });
    return mapfiedTasks;
  }
   
   
  bool checkAchieved() {
    bool checkAchieved = true;
    this.tasks.forEach((element) {
      if (element.achievedTasks != element.taskRepetition) {
        //not all tasks are achived
        checkAchieved = false;
      }
    }); //end forEach
    return checkAchieved; //all tasks are achived
  } // end checkAchieved()

  double calcProgress() {
    //Rewrite
    int totalTasks = this.numOfTasks;
    double achivedTasks = 0.0;
    this.tasks.forEach((element) {
      achivedTasks += element.achievedTasks;
    });
    return (achivedTasks / totalTasks);
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
      deadline: map['deadline'].toDate(),
      tasks: newList,
      docID: docID,
      isAchieved: map["isAchieved"],
      creationDate: map['creationDate'].toDate(),
      numOfTasks: map['numOfTasks'],
    );
  }

  int clacTasks() {
    int totalTasks = 0;
    this.tasks.forEach((element) {
      totalTasks += element.calcRepetition(deadline, creationDate);
    }); //end forEach

    return totalTasks;
  }

  int calcAchievedTasks() {
    int count = 0;
    this.tasks.forEach((element) {
      count += element.achievedTasks;
    }); //end forEach
    return count;
  }
}

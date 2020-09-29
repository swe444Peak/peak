import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:peak/models/task.dart';

class Goal {
  final String goalName;
  final String uID;
  final DateTime deadline;
  final String docID;
  final int numberOfTaksPerDay;
  final List<Task> tasks;
  final bool isAchieved;

  Goal(
      {@required this.goalName,
      @required this.uID,
      @required this.deadline,
      this.docID,
      this.numberOfTaksPerDay,
      this.tasks,
      this.isAchieved = false,});



  Map<String, dynamic> toMap() {
    return {
      "goalName": this.goalName,
      "uID": this.uID,
      "deadLine": Timestamp.fromMicrosecondsSinceEpoch(
          this.deadline.microsecondsSinceEpoch),
      "numberOfTaksPerDay": this.numberOfTaksPerDay,
      "tasks": this.mapfy(),
      "isAchieved": this.isAchieved,
    };
  }

  List<Map<String, dynamic>> mapfy() {
    List<Map<String, dynamic>> mapfiedTasks = List<Map<String, dynamic>>();
    this.tasks.forEach((element) {
      mapfiedTasks.add(element.toMap());
    });
    return mapfiedTasks;
  }

  static Goal fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }
    List<dynamic> taskList = map['tasks'];
    List<Task> newList = List<Task>();
    taskList.forEach((element) {newList.add(Task.fromJson(element));});
    return Goal(
      goalName: map['goalName'],
      uID: map['uID'],
      deadline: map['deadLine'].toDate(),
      tasks: newList,
      //docID: 
      numberOfTaksPerDay: map['numberOfTaksPerDay'],
      isAchieved: map["isAchieved"],
    );
  }
}

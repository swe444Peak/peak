import 'package:flutter/cupertino.dart';
import 'package:peak/models/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Goal {
  final String goalName;
  final String uID;
  final DateTime deadLine;
  final String docID;
  final int numberOfTaksPerDay;
  final List<Task> tasks;

  Goal(
      {@required this.goalName,
      @required this.uID,
      @required this.deadLine,
      this.docID,
      this.numberOfTaksPerDay,
      this.tasks});

  Map<String, dynamic> toMap(){
    return  {
      "goalName": this.goalName,
      "uID": this.uID,
      "deadLine": Timestamp.fromMicrosecondsSinceEpoch(this.deadLine.microsecondsSinceEpoch),
      "numberOfTaksPerDay": this.numberOfTaksPerDay,
      //"tasks": this.mapfy(),
    };
  }

  List<Map<String, dynamic>> mapfy(){
    List<Map<String, dynamic>> mapfiedTasks = List<Map<String, dynamic>>();
    this.tasks.forEach((element) {mapfiedTasks.add(element.toMap());});
    return mapfiedTasks;
  }

}

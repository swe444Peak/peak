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
  final DateTime creationDate;

  Goal({
    @required this.goalName,
    @required this.uID,
    @required this.deadline,
    this.docID,
    this.numberOfTaksPerDay = 1,
    this.tasks,
    this.isAchieved = false,
    this.creationDate,
  });

  Map<String, dynamic> toMap() {
    return {
      "goalName": this.goalName,
      "uID": this.uID,
      "deadLine": Timestamp.fromMicrosecondsSinceEpoch(
          this.deadline.microsecondsSinceEpoch),
      "numberOfTaksPerDay": this.numberOfTaksPerDay,
      "tasks": this.mapfy(),
      "isAchieved": (this.isAchieved? true :this.checkAchieved()),
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

  bool checkAchieved(){
    this.tasks.forEach((element) {
      if(!element.done)
        return false;     //not all tasks are achived 
    }); //end forEach
    return true;          //all tasks are achived 
  }// end checkAchieved()

  double calcProgress(){
    int totalTasks = this.tasks.length ;
    double achivedTasks = 0.0;
    this.tasks.forEach((element) {if(element.done) achivedTasks++ ;});
    if(achivedTasks == 0){
      return 0.0;
    }
    return (achivedTasks/totalTasks) ;
  } //end calcProgress()

  
  static Goal fromJson(Map<String, dynamic> map, String docID) {
    if (map == null || map['tasks'] == null) {
      return null;
    }
    List<dynamic> taskList = map['tasks'];
    List<Task> newList = List<Task>();
    taskList.forEach((element) {
      newList.add(Task.fromJson(element));
    });
    return Goal(
        goalName: map['goalName'],
        uID: map['uID'],
        deadline: map['deadLine'].toDate(),
        tasks: newList,
        docID: docID,
        numberOfTaksPerDay: map['numberOfTaksPerDay'],
        isAchieved: map["isAchieved"],
        creationDate: map['creationDate'].toDate());
  }
}

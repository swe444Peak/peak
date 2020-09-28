import 'package:flutter/cupertino.dart';
import 'package:peak/Models/task.dart';

class Goal {
  final String goalName;
  final String uID;
  final DateTime deadline;
  final String docID;
  final int numberOfTaksPerDay;
  final List<Task> tasks;

  Goal(
      {@required this.goalName,
      @required this.uID,
      @required this.deadline,
      this.docID,
      this.numberOfTaksPerDay,
      this.tasks});

  static Goal fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }
    return Goal(
      goalName: map['goalName'],
      uID: map['uID'],
      deadline: map['deadLine'].toDate(),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:peak/Models/task.dart';
import 'dart:core/';

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
}

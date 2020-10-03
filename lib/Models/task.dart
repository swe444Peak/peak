import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:peak/enums/taskType.dart';

abstract class Task {
  final String taskName;
  final bool done;
  final TaskType taskType;
  Task({@required this.taskName, this.done = false, @required this.taskType});

  Map<String, dynamic> toMap() {
    return {
      "taskName": this.taskName,
      "done": this.done,
      "taskType": this.taskType.toShortString(),
    };
  }
}

class DailyTask extends Task {
  DailyTask({@required taskName, done = false})
      : super(taskName: taskName, taskType: TaskType.daily);
  @override
  Map<String, dynamic> toMap() {
    return {
      "taskName": this.taskName,
      "done": this.done,
      "taskType": this.taskType.toShortString(),
    };
  }

  static Task fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }
    return DailyTask(
      taskName: map['taskName'],
      done: map['done'],
    );
  }
}

class OnceTask extends Task {
  final DateTime date;
  OnceTask({@required taskName, @required this.date, done = false})
      : super(taskName: taskName, taskType: TaskType.once, done: done);
  @override
  Map<String, dynamic> toMap() {
    return {
      "taskName": this.taskName,
      "done": this.done,
      "date": Timestamp.fromMicrosecondsSinceEpoch(
          this.date.microsecondsSinceEpoch),
      "taskType": this.taskType.toShortString(),
    };
  }

  static Task fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }
    return OnceTask(
        taskName: map['taskName'],
        done: map['done'],
        date: map['date'].toDate());
  }
}

class WeeklyTask extends Task {
  /*
    monday:1
    tuesday:2
    wednesday:3
    thursday:4
    friday:5
    saturday:6
    sunday:7
  */
  int weekday; /*The day of the week monday..sunday*/
  WeeklyTask({@required taskName, @required this.weekday, done = false})
      : super(taskName: taskName, taskType: TaskType.weekly, done: done);

  @override
  Map<String, dynamic> toMap() {
    return {
      "taskName": this.taskName,
      "done": this.done,
      "taskType": this.taskType.toShortString(),
      "weekday": this.weekday,
    };
  }

  static Task fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }
    return WeeklyTask(
      taskName: map['taskName'],
      done: map['done'],
      weekday: map['weekday'],
    );
  }
}

class MonthlyTask extends Task {
  int day; /*The day of the month 1..31*/

  MonthlyTask({@required taskName, @required this.day, done = false})
      : super(taskName: taskName, taskType: TaskType.monthly, done: done);

  Map<String, dynamic> toMap() {
    return {
      "taskName": this.taskName,
      "done": this.done,
      "taskType": this.taskType.toShortString(),
      "day": this.day,
    };
  }

  static Task fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }
    return MonthlyTask(
      taskName: map['taskName'],
      done: map['done'],
      day: map['day'],
    );
  }
}

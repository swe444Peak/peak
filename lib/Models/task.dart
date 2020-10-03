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

  bool isAtSameDate(DateTime dat1, DateTime date2){
    if(dat1.day == date2.day){
      if(dat1.month == date2.month)
        if(dat1.year == date2.year)
          return true;
    }//end if
    return false;
  }

  int calcRepetation(DateTime dueDate , DateTime creation);
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

  @override
  int calcRepetation(DateTime dueDate, DateTime creation) {
    return (creation.difference(dueDate)).inDays;
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

  @override
  int calcRepetation(DateTime dueDate, DateTime creation) {
    return 1;
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
  List<int> weekdays; /*The day of the week monday..sunday*/
  WeeklyTask({@required taskName, @required this.weekdays, done = false})
      : super(taskName: taskName, taskType: TaskType.weekly, done: done);

  @override
  Map<String, dynamic> toMap() {
    return {
      "taskName": this.taskName,
      "done": this.done,
      "taskType": this.taskType.toShortString(),
      "weekdays": this.weekdays,
    };
  }

  static Task fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }
    return WeeklyTask(
      taskName: map['taskName'],
      done: map['done'],
      weekdays: map['weekdays'],
    );
  }

  @override
  int calcRepetation(DateTime dueDate, DateTime creation) {
    int repetation = 0;
    if(this.isAtSameDate(dueDate, creation)){   //if creation == dueDate
      weekdays.forEach((element) {
        if(creation.weekday == element)
          repetation++;
      });//end forEach
      return repetation;
    }

    int duration = creation.difference(dueDate).inDays;
    for(int i=0; i<duration ; i++){     //if creation != dueDate
      creation.add(Duration(days: 1));
      weekdays.forEach((element) {
        if(creation.weekday == element)
          repetation++;
      });//end forEach
      if(this.isAtSameDate(dueDate, creation))
        return repetation;
    }//end for
    return repetation;
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

  @override
  int calcRepetation(DateTime dueDate, DateTime creation) {
    int repetation = 0;
    if(this.isAtSameDate(dueDate, creation)){   //if creation == dueDate
      if(creation.day == day){
        repetation++;
        return repetation;
      }
    }//end if

    int duration = creation.difference(dueDate).inDays;
    for(int i=0; i<duration ; i++){     //if creation != dueDate
      creation.add(Duration(days: 1));
      if(creation.day == day)
        repetation++;
      if(this.isAtSameDate(dueDate, creation))
        return repetation;
    }//end for
    return repetation;
  }
}

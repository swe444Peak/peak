import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:peak/enums/taskType.dart';

abstract class Task {
  final String taskName;
  final TaskType taskType;
  int taskRepetition;
  int achievedTasks;
  Task(
      {@required this.taskName,
      @required this.taskType,
      this.taskRepetition,
      this.achievedTasks = 0});

  Map<String, dynamic> toMap() {
    return {
      "taskName": this.taskName,
      "taskType": this.taskType.toShortString(),
      "taskRepetition": this.taskRepetition,
      "achievedTasks": this.achievedTasks,
    };
  }

<<<<<<< HEAD
  bool isDone(){
    return (this.taskRepetition == this.achievedTasks);
  }

  bool isAtSameDate(DateTime dat1, DateTime date2){
    if(dat1.day == date2.day){
      if(dat1.month == date2.month)
        if(dat1.year == date2.year)
          return true;
    }//end if
=======
  bool isAtSameDate(DateTime dat1, DateTime date2) {
    if (dat1.day == date2.day) {
      if (dat1.month == date2.month) if (dat1.year == date2.year) return true;
    } //end if
>>>>>>> 5c2f25608626841c6dac86cc18d409f041992272
    return false;
  }

  int calcRepetition(DateTime dueDate, DateTime creation);
}

class DailyTask extends Task {
  DailyTask({@required taskName, taskRepetition, achievedTasks = 0})
      : super(
            taskName: taskName,
            taskType: TaskType.daily,
            taskRepetition: taskRepetition,
            achievedTasks: achievedTasks);
  @override
  Map<String, dynamic> toMap() {
    //TO DO add repetition
    return {
      "taskName": this.taskName,
      "taskType": this.taskType.toShortString(),
      "taskRepetition": this.taskRepetition,
      "achievedTasks": this.achievedTasks,
    };
  }

  static Task fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }
    return DailyTask(
      taskName: map['taskName'],
      taskRepetition: map["taskRepetition"],
      achievedTasks: map['achievedTasks'],
    );
  }

  @override
  int calcRepetition(DateTime dueDate, DateTime creation) {
    this.taskRepetition = (creation.difference(dueDate)).inDays;
    return taskRepetition;
  }
}

class OnceTask extends Task {
  final DateTime date;
  final bool done;
  OnceTask(
      {@required taskName,
      @required this.date,
      this.done = false,
      taskRepetition,
      achievedTasks = 0})
      : super(
          taskName: taskName,
          taskType: TaskType.once,
          taskRepetition: taskRepetition,
          achievedTasks: achievedTasks,
        );
  @override
  Map<String, dynamic> toMap() {
    return {
      "taskName": this.taskName,
      "done": this.done,
      "date": Timestamp.fromMicrosecondsSinceEpoch(
          this.date.microsecondsSinceEpoch),
      "taskType": this.taskType.toShortString(),
      "taskRepetition": this.taskRepetition,
      "achievedTasks": this.achievedTasks,
    };
  }

  static Task fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }
    return OnceTask(
      taskName: map['taskName'],
      done: map['done'],
      date: map['date'].toDate(),
      taskRepetition: map["taskRepetition"],
      achievedTasks: map['achievedTasks'],
    );
  }

  @override
  int calcRepetition(DateTime dueDate, DateTime creation) {
    this.taskRepetition = 1;
    return taskRepetition;
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
  WeeklyTask(
      {@required taskName,
      @required this.weekdays,
      taskRepetition,
      achievedTasks = 0})
      : super(
            taskName: taskName,
            taskType: TaskType.weekly,
            taskRepetition: taskRepetition,
            achievedTasks: achievedTasks);

  @override
  Map<String, dynamic> toMap() {
    return {
      "taskName": this.taskName,
      "taskType": this.taskType.toShortString(),
      "weekdays": this.weekdays,
      "taskRepetition": this.taskRepetition,
      "achievedTasks": this.achievedTasks,
    };
  }

  static Task fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }
    return WeeklyTask(
      taskName: map['taskName'],
      weekdays: map['weekdays'],
      taskRepetition: map["taskRepetition"],
      achievedTasks: map['achievedTasks'],
    );
  }

  @override
  int calcRepetition(DateTime dueDate, DateTime creation) {
    int repetition = 0;
    if (this.isAtSameDate(dueDate, creation)) {
      //if creation == dueDate
      weekdays.forEach((element) {
        if (creation.weekday == element) repetition++;
      }); //end forEach
      taskRepetition = repetition;
      return repetition;
    }

    int duration = creation.difference(dueDate).inDays;
    for (int i = 0; i < duration; i++) {
      //if creation != dueDate
      creation.add(Duration(days: 1));
      weekdays.forEach((element) {
        if (creation.weekday == element) repetition++;
      }); //end forEach
      if (this.isAtSameDate(dueDate, creation)) taskRepetition = repetition;
      return repetition;
    } //end for
    taskRepetition = repetition;
    return repetition;
  }
}

class MonthlyTask extends Task {
  int day; /*The day of the month 1..31*/

  MonthlyTask(
      {@required taskName,
      @required this.day,
      taskRepetition,
      achievedTasks = 0})
      : super(
          taskName: taskName,
          taskType: TaskType.monthly,
          taskRepetition: taskRepetition,
          achievedTasks: achievedTasks,
        );

  Map<String, dynamic> toMap() {
    return {
      "taskName": this.taskName,
      "taskType": this.taskType.toShortString(),
      "day": this.day,
      "taskRepetition": this.taskRepetition,
      "achievedTasks": this.achievedTasks,
    };
  }

  static Task fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }
    return MonthlyTask(
      taskName: map['taskName'],
      day: map['day'],
      taskRepetition: map["taskRepetition"],
      achievedTasks: map['achievedTasks'],
    );
  }

  @override
  int calcRepetition(DateTime dueDate, DateTime creation) {
    int repetition = 0;
    if (this.isAtSameDate(dueDate, creation)) {
      //if creation == dueDate
      if (creation.day == day) {
        repetition++;
        taskRepetition = repetition;
        return repetition;
      }
    } //end if

    int duration = creation.difference(dueDate).inDays;
    for (int i = 0; i < duration; i++) {
      //if creation != dueDate
      creation.add(Duration(days: 1));
      if (creation.day == day) repetition++;
      if (this.isAtSameDate(dueDate, creation)) taskRepetition = repetition;
      return repetition;
    } //end for
    taskRepetition = repetition;
    return repetition;
  }
}

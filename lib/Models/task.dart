import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:peak/enums/taskType.dart';

abstract class Task {
  String taskName;
  final TaskType taskType;
  int taskRepetition;
  int achievedTasks;
  int id;

  Task({
    @required this.taskName,
    @required this.taskType,
    this.id,
    this.taskRepetition,
    this.achievedTasks = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      "taskName": this.taskName,
      "taskType": this.taskType.toShortString(),
      "taskRepetition": this.taskRepetition,
      "achievedTasks": this.achievedTasks,
    };
  }

  bool isDone() {
    return (this.taskRepetition == this.achievedTasks);
  }

  bool isAtSameDate(DateTime date1, DateTime date2) {
    if (date1.day == date2.day) {
      if (date1.month == date2.month) if (date1.year == date2.year) return true;
    } //end if
    return false;
  }

  int calcRepetition(DateTime dueDate, DateTime creation);

  static List<DateTime> castDates(List<dynamic> dates){
    List<DateTime> castedDates = new List<DateTime>();
    dates.forEach((date) {
      castedDates.add(date.toDate());
     });
    return castedDates;
  }
}

class DailyTask extends Task {
  List<DateTime> doneDates = List<DateTime>();
  DailyTask(
      {@required taskName, taskRepetition, achievedTasks = 0, this.doneDates, id})
      : super(
            taskName: taskName,
            taskType: TaskType.daily,
            id: id,
            taskRepetition: taskRepetition,
            achievedTasks: achievedTasks);
  @override
  Map<String, dynamic> toMap() {
    return {
      "taskName": this.taskName,
      "taskType": this.taskType.toShortString(),
      "taskRepetition": this.taskRepetition,
      "achievedTasks": this.achievedTasks,
      "doneDates": this.doneDates,
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
      doneDates: Task.castDates(map['doneDates']),
    );
  }

  @override
  int calcRepetition(DateTime dueDate, DateTime creation) {
    this.taskRepetition = (dueDate.difference(creation)).inDays + 1;
    return taskRepetition;
  }
}

class OnceTask extends Task {
  final DateTime date;
  bool done;
  OnceTask(
      {@required taskName,
      @required this.date,
      id,
      this.done = false,
      taskRepetition,
      achievedTasks = 0})
      : super(
          taskName: taskName,
          taskType: TaskType.once,
          id: id,
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
    if (date.isBefore(dueDate) || this.isAtSameDate(dueDate, date))
      this.taskRepetition = 1;
    else {
      taskRepetition = 0;
    }
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
  List<DateTime> dates = List<DateTime>();
  List<DateTime> doneDates = List<DateTime>();
  List<int> weekdays = List<int>(); /*The day of the week monday..sunday*/
  WeeklyTask(
      {@required taskName,
      @required this.weekdays,
      id,
      taskRepetition,
      achievedTasks = 0,
      })
      : super(
            taskName: taskName,
            taskType: TaskType.weekly,
            id: id,
            taskRepetition: taskRepetition,
            achievedTasks: achievedTasks);

  WeeklyTask.withDates(
      {@required taskName,
      @required this.weekdays,
      this.dates,
      taskRepetition,
      achievedTasks = 0,
      this.doneDates})
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
      "dates": this.dates,
      "taskRepetition": this.taskRepetition,
      "achievedTasks": this.achievedTasks,
      "doneDates": this.doneDates,
    };
  }

  static Task fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }

    return WeeklyTask.withDates(
      taskName: map['taskName'],
      weekdays: List.castFrom(map['weekdays']),
      taskRepetition: map["taskRepetition"],
      achievedTasks: map['achievedTasks'],
      dates: Task.castDates(map['dates']),
      doneDates: Task.castDates(map['doneDates']),
    );
  }

  String weekdaysList() {
    String days = "";
    this.weekdays.forEach((element) {
      switch (element) {
        case 1:
          days = days + "monday ";
          break;
        case 2:
          days = days + "tuesday ";
          break;
        case 3:
          days = days + "wednesday ";
          break;
        case 4:
          days = days + "thursday ";
          break;
        case 5:
          days = days + "friday ";
          break;
        case 6:
          days = days + "saturday ";
          break;
        case 7:
          days = days + "sunday ";
          break;
      }
    });
    days = days.trimRight();
    days.replaceAll(" ", ", ");
    return days;
  }

  @override
  int calcRepetition(DateTime dueDate, DateTime creation) {
    int repetition = 0;
    this.dates = [];

    if (this.isAtSameDate(dueDate, creation)) {
      weekdays.forEach((element) {
        if (creation.weekday == element) {
          repetition++;
          dates.add(creation);
        }
      }); //end forEach
      taskRepetition = repetition;
      return repetition;
    }

    int duration = (dueDate.difference(creation)).inDays + 1;
    for (int i = 0; i < duration; i++) {
      weekdays.forEach((element) {
        if (creation.weekday == element) {
          repetition++;
          dates.add(creation);
        }
      }); //end forEach
      if (this.isAtSameDate(dueDate, creation)) {
        taskRepetition = repetition;
        return repetition;
      }
      creation = creation.add(Duration(days: 1));
    } //end for
    taskRepetition = repetition;
    return repetition;
  }
}

class MonthlyTask extends Task {
  int day; /*The day of the month 1..31*/
  List<DateTime> dates = List<DateTime>();
  List<DateTime> doneDates = List<DateTime>();
  MonthlyTask({
    @required taskName,
    @required this.day,
    id,
    taskRepetition,
    achievedTasks = 0,
  }) : super(
          taskName: taskName,
          taskType: TaskType.monthly,
          id: id,
          taskRepetition: taskRepetition,
          achievedTasks: achievedTasks,
        );

  MonthlyTask.withDates({
    @required taskName,
    @required this.day,
    this.dates,
    taskRepetition,
    achievedTasks = 0,
    this.doneDates,
  }) : super(
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
      "dates": this.dates,
      "taskRepetition": this.taskRepetition,
      "achievedTasks": this.achievedTasks,
      "doneDates": this.doneDates,
    };
  }

  static Task fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }
    return MonthlyTask.withDates(
      taskName: map['taskName'],
      day: map['day'],
      dates: Task.castDates(map['dates']),
      taskRepetition: map["taskRepetition"],
      achievedTasks: map['achievedTasks'],
      doneDates: Task.castDates(map['doneDates']),
    );
  }

  @override
  int calcRepetition(DateTime dueDate, DateTime creation) {
    int repetition = 0;
    this.dates = [];
    if (this.isAtSameDate(dueDate, creation)) {
      //if creation == dueDate
      if (creation.day == day) {
        repetition++;
        dates.add(creation);
        taskRepetition = repetition;
        return repetition;
      }
    } //end if

    int duration = dueDate.difference(creation).inDays + 1;

    for (int i = 0; i < duration; i++) {
      //if creation != dueDate

      if (creation.day == day) {
        dates.add(creation);
        repetition++;
      }
      if (this.isAtSameDate(dueDate, creation)) {
        taskRepetition = repetition;
        return repetition;
      }
      creation = creation.add(Duration(days: 1));
    } //end for
    taskRepetition = repetition;
    return repetition;
  }
}

import 'package:flutter/material.dart';
import 'package:peak/enums/taskType.dart';
import 'package:peak/services/dialogService.dart';

import 'package:weekday_selector/weekday_selector.dart';
import 'package:peak/models/task.dart';

import '../locator.dart';

class EditTask extends StatefulWidget {
  var width;
  var height;
  Function showError;

  List<Task> tasks;
  DateTime deadline;
  EditTask(Key key, this.tasks, this.width, this.height, this.showError,
      this.deadline)
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new EditTaskState();
}

class EditTaskState extends State<EditTask> {
  DialogService _dialogService = locator<DialogService>();
  String repetitionError;
  var values = [true, false, false, false, false, false, false];
  DateTime deadline;
  DateTime _dateTime;
  DateTime now = DateTime.now();
  String dropdownValue;
  String currentValue;
  String error;
  String updateError;
  List<Widget> tasksList = [];
  TextEditingController _taskcontroller = TextEditingController();
  TextEditingController _updateController = new TextEditingController();
  var repItems;
  int editIndex;
  bool dateChanged;
  bool dropDownChanged;

  @override
  Widget build(BuildContext context) {
    return new ListView(
        shrinkWrap: true, physics: ScrollPhysics(), children: tasksList);
  }

  @override
  void initState() {
    super.initState();
    deadline = widget.deadline;
    buildTasks(null);
  }

  List<Widget> buildTasks(int editIndex) {
    repItems = ['Daily', 'Weekly', 'Monthly', 'Once'];

    tasksList = [];
    if (editIndex != null) {
      dateChanged = false;
      dropDownChanged = false;
      //in case user wants to edit an exsting task
      if (_updateController.text.isEmpty && updateError == null) {
        _updateController =
            new TextEditingController(text: widget.tasks[editIndex].taskName);
      }

      if (dropdownValue == null) {
        dropdownValue = ((widget.tasks[editIndex].taskType.toShortString())[0]
                .toUpperCase() +
            (widget.tasks[editIndex].taskType.toShortString()).substring(1));
        currentValue = ((widget.tasks[editIndex].taskType.toShortString())[0]
                .toUpperCase() +
            (widget.tasks[editIndex].taskType.toShortString()).substring(1));
      } //end if

      tasksList.add(Card(
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.width * 0.08),
            child: Column(
              children: [
                Row(
                  //card titile
                  children: [
                    Text(
                      "Edit Task",
                      style: TextStyle(
                        color: Colors.indigo[900],
                        fontSize: widget.width * 0.05,
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: _updateController,
                  decoration: InputDecoration(
                    labelText: 'Task Name',
                    labelStyle: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 19,
                    ),
                    errorText: updateError,
                  ),
                  style: TextStyle(fontSize: widget.width * 0.04),
                  onChanged: (_) {
                    setState(() {
                      if (_updateController.text.isNotEmpty) {
                        updateError = null;
                        buildTasks(editIndex);
                      }
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  hint: Text("Repetition"),
                  style: TextStyle(
                      color: Colors.grey[700], fontSize: widget.width * 0.04),
                  value: dropdownValue,
                  onChanged: (newValue) {
                    setState(() {
                      widget.tasks[editIndex].taskName = _updateController.text;
                      _dateTime = DateTime.now();
                      dropdownValue = newValue;
                      currentValue = newValue;
                      buildTasks(editIndex);
                      dropDownChanged = true;
                    });
                  },
                  items: repItems.map<DropdownMenuItem<String>>((value) {
                    //currentValue = value;
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                repeatDate(
                    index: editIndex,
                    creationDate: widget.tasks[editIndex].creationDate),
                Padding(
                  padding: EdgeInsets.all(widget.width * 0.04),
                  child: ButtonTheme(
                    minWidth: 150.0,
                    height: 50.0,
                    child: RaisedButton(
                      splashColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      color: Color.fromRGBO(23, 23, 85, 1.0),
                      onPressed: () {
                        _onUpdateAt(editIndex);
                      },
                      textColor: Colors.white,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )));
    } else {
      tasksList.add(Card(
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.width * 0.08),
            child: Column(
              children: [
                Row(
                  //card titile
                  children: [
                    Text(
                      "Add New Task",
                      style: TextStyle(
                        color: Colors.indigo[900],
                        fontSize: widget.width * 0.05,
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: _taskcontroller,
                  decoration: InputDecoration(
                    labelText: 'Task Name',
                    errorText: error,
                  ),
                  style: TextStyle(fontSize: widget.width * 0.04),
                  onChanged: (_) {
                    setState(() {
                      error = null;
                      buildTasks(null);
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  hint: Text("Repetition"),
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: widget.width * 0.04,
                  ),
                  value: dropdownValue,
                  onTap: () {
                    if (deadline == null) {
                      setState(() {
                        widget.showError(
                            "Please pick a goal due date so you can be able to add a task");
                      });
                    }
                  },
                  onChanged: (newValue) {
                    setState(() {
                      repetitionError = null;
                      dropdownValue = newValue;
                      currentValue = newValue;
                      buildTasks(null);
                    });
                  },
                  decoration: InputDecoration(
                    errorText: repetitionError,
                  ),
                  items: repItems.map<DropdownMenuItem<String>>((value) {
                    //currentValue = value;
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),

                repeatDate(
                    creationDate: DateTime.now()), //add the user selection !!!

                Padding(
                  padding: EdgeInsets.all(widget.width * 0.04),
                  child: ButtonTheme(
                    minWidth: 100.0,
                    height: 50.0,
                    child: RaisedButton(
                      splashColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      color: Color.fromRGBO(23, 23, 85, 1.0),
                      onPressed: _onSave,
                      textColor: Colors.white,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )));
    }

    for (int index = 0; index < widget.tasks.length; index++) {
      var isValid = true;
      if (editIndex != null && editIndex == index) continue;
      var currentTask;
      var currentTaskType = widget.tasks[index].taskType;
      if (currentTaskType == TaskType.monthly) {
        currentTask = widget.tasks[index] as MonthlyTask;
      } else if (currentTaskType == TaskType.once) {
        currentTask = widget.tasks[index] as OnceTask;
      } else if (currentTaskType == TaskType.weekly) {
        currentTask = widget.tasks[index] as WeeklyTask;
      } else if (currentTaskType == TaskType.daily) {
        currentTask = widget.tasks[index] as DailyTask;
      }
      if (currentTask.calcRepetition(deadline, currentTask.creationDate) == 0) {
        isValid = false;
      }
      tasksList.add(Card(
        child: Padding(
          padding: EdgeInsets.all(widget.width * 0.008),
          child: ListTile(
            leading: new IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  if (await _confirmRemove()) _removeLabelAt(index);
                }),
            title: Text(widget.tasks[index].taskName),
            subtitle: Text(
                "Repetition: ${widget.tasks[index].taskType.toShortString()}" +
                    ((widget.tasks[index].taskType == TaskType.daily)
                        ? ""
                        : (widget.tasks[index].taskType == TaskType.monthly
                            ? " on ${currentTask.day}"
                            : (widget.tasks[index].taskType == TaskType.once
                                ? " on ${currentTask.date.toString().split(" ").first}"
                                : " on ${currentTask.weekdaysList()}")))),
            trailing: new IconButton(
                icon: isValid
                    ? Icon(Icons.edit)
                    : Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                onPressed: () => _editLabelAt(index, isValid)),
          ),
        ),
      ));
    }

    return tasksList;
  } //end buildTasks

  _onSave() {
    setState(() {
      if (_taskcontroller.text.trim().isNotEmpty && dropdownValue != null) {
        var task = creatTask(
            taskName: _taskcontroller.text,
            taskType: currentValue.formString());
        if (currentValue.formString() == TaskType.weekly &&
            task.taskRepetition == 0) {
          buildTasks(null);
          widget.showError(
              "Oops, the chosen days have no repetition. Please select other days that are within the due date duration");
        } else {
          widget.tasks.add(task);
          _taskcontroller.clear();
          values = [true, false, false, false, false, false, false];
          error = null;
          repetitionError = null;
          dropdownValue = null;
          currentValue = null;
          _dateTime = DateTime.now();
          buildTasks(null);
        }
      } else {
        if (dropdownValue == null)
          repetitionError = "Task repetition must be selected! ";
        if (_taskcontroller.text.trim().isEmpty) error = 'Enter a name!';
        buildTasks(null);
      }
    });
  }

  _removeLabelAt(int index) {
    setState(() {
      widget.tasks.removeAt(index);
      buildTasks(null);
    });
  }

  Future<bool> _confirmRemove() async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Delete task',
      description: 'are you sure you want to delete this task',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );
    return dialogResponse.confirmed;
  }

  _editLabelAt(index, [isValid]) {
    setState(() {
      if (!isValid) {
        widget.showError("Task's date is invalid, try choosing another date");
      }
      _updateController.clear();
      dropdownValue = null;
      currentValue = null;

      var currentTask;
      var currentTaskType = widget.tasks[index].taskType;
      if (currentTaskType == TaskType.monthly) {
        currentTask = widget.tasks[index] as MonthlyTask;
        _dateTime = DateTime(
            DateTime.now().year, DateTime.now().month, currentTask.day);
      } else if (currentTaskType == TaskType.once) {
        currentTask = widget.tasks[index] as OnceTask;
        _dateTime = currentTask.date;
      } else if (currentTaskType == TaskType.weekly) {
        currentTask = widget.tasks[index] as WeeklyTask;
        values = [false, false, false, false, false, false, false];
        currentTask.weekdays.forEach((element) {
          values[element % 7] = true;
        });
      }

      buildTasks(index);
    });
  }

  _onUpdateAt(index) {
    setState(() {
      if (_updateController.text.trim().isNotEmpty) {
        if (currentValue.formString() == TaskType.weekly &&
            widget.tasks[index].calcRepetition(
                    deadline, widget.tasks[index].creationDate) ==
                0) {
          buildTasks(index);
          widget.showError(
              "Oops, the chosen days have no repetition. Please select other days that are within the due date duration");
        } else {
          if (dateChanged || dropDownChanged) {
            widget.tasks.removeAt(index);
            widget.tasks.add(creatTask(
                taskName: _updateController.text,
                taskType: currentValue.formString()));
          } else {
            widget.tasks[index].taskName = _updateController.text;
          }

          dropdownValue = null;
          currentValue = null;
          values = [true, false, false, false, false, false, false];
          _updateController.clear();
          _dateTime = DateTime.now();
          updateError = null;
          buildTasks(null);
        }
      } else {
        updateError = 'Enter a name!';
        buildTasks(index);
      }
    });
  }

  Widget repeatDate({int index, creationDate}) {
    if (currentValue == "Daily") {
      if (isAtSameDate(deadline, creationDate)) {
        return Text("*This task will repeat only once",
            style: TextStyle(
                fontFamily: 'Montserrat', fontSize: 18.0, color: Colors.teal),
            textAlign: TextAlign.center);
      } else {
        return Text("*This task will repeat daily",
            style: TextStyle(
                fontFamily: 'Montserrat', fontSize: 18.0, color: Colors.teal),
            textAlign: TextAlign.center);
      }
    } else if (currentValue == "Weekly") {
      return Column(
        children: [
          Text("*This task will repeat weekly on the days you pick",
              style: TextStyle(
                  fontFamily: 'Montserrat', fontSize: 18.0, color: Colors.teal),
              textAlign: TextAlign.center),
          WeekdaySelector(
            selectedFillColor: Colors.lightBlue[600],
            onChanged: (v) {
              setState(() {
                if (onlyOneDay(values) && values[v % 7] == true) {
                } else {
                  values[v % 7] = !values[v % 7];
                  if (index != null) {
                    widget.tasks[index].taskName = _updateController.text;
                  }
                  buildTasks(index);
                  dateChanged = true;
                }
              });
            },
            values: values,
          )
        ],
      );
    } else if (currentValue == "Monthly") {
      if (isAtSameDate(deadline, creationDate)) {
        return Text("*This task will repeat only once",
            style: TextStyle(
                fontFamily: 'Montserrat', fontSize: 18.0, color: Colors.teal),
            textAlign: TextAlign.center);
      } else {
        if (_dateTime == null ||
            _dateTime.isAfter(deadline.subtract(Duration(days: 1)))) {
          _dateTime = DateTime.now();
        }
        print(_dateTime.toString());
        print(deadline.toString());
        return Column(
          children: [
            Text("*Pick the starting day for your monthly task",
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18.0,
                    color: Colors.teal),
                textAlign: TextAlign.center),
            CalendarDatePicker(
                initialDate: _dateTime == null ||
                        _dateTime.isBefore(deadline.subtract(Duration(days: 1)))
                    ? DateTime.now()
                    : _dateTime,
                firstDate: DateTime.now(),
                lastDate: deadline.subtract(Duration(days: 1)),
                onDateChanged: (d) {
                  _dateTime = d;
                  print(_dateTime.toString() + "ffff");
                  buildTasks(null);
                  dateChanged = true;
                })
          ],
        );
      }
    } else if (currentValue == "Once") {
      print("inside once");
      if (_dateTime == null ||
          _dateTime.isAfter(deadline.subtract(Duration(days: 1)))) {
        _dateTime = DateTime.now();
      }

      if (isAtSameDate(deadline, creationDate)) {
        return Text("*This task will repeat only once",
            style: TextStyle(
                fontFamily: 'Montserrat', fontSize: 18.0, color: Colors.teal),
            textAlign: TextAlign.center);
      }
      return CalendarDatePicker(
          initialDate: _dateTime == null ||
                  _dateTime.isAfter(deadline.subtract(Duration(days: 1)))
              ? DateTime.now()
              : _dateTime,
          firstDate: DateTime.now(),
          lastDate: deadline.subtract(Duration(days: 1)),
          onDateChanged: (d) {
            print("inside repeat if");
            dateChanged = true;
            _dateTime = d;
          });
    }
    return SizedBox(
      height: 0,
    );
  }

  Task creatTask({TaskType taskType, @required String taskName}) {
    switch (taskType) {
      case TaskType.daily:
        var task = DailyTask(taskName: taskName, creationDate: DateTime.now());
        task.calcRepetition(deadline, DateTime.now());
        return task;
      case TaskType.once:
        var date = _dateTime == null ? DateTime.now() : _dateTime;
        var task = OnceTask(
            taskName: taskName, date: date, creationDate: DateTime.now());
        task.calcRepetition(deadline, DateTime.now());
        return task;
      case TaskType.weekly:
        List<int> days = [];
        var temp = values[0];
        values.removeAt(0);
        values.insert(6, temp);
        for (int i = 0; i < 7; i++) {
          if (values[i]) {
            days.add(i + 1);
          }
        }

        var task = WeeklyTask(
            taskName: taskName, weekdays: days, creationDate: DateTime.now());
        task.calcRepetition(deadline, DateTime.now());
        return task;
      case TaskType.monthly:
        var day = _dateTime == null ? DateTime.now().day : _dateTime.day;
        var task = MonthlyTask(
            taskName: taskName, day: day, creationDate: DateTime.now());
        task.calcRepetition(deadline, DateTime.now());
        return task;
    }
  }

  bool onlyOneDay(List<bool> values) {
    int counter = 0;
    for (int i = 0; i < values.length; i++) {
      if (values[i] == true) counter++;
    }
    if (counter == 1) {
      return true;
    }
    return false;
  }

  bool isAtSameDate(DateTime date1, DateTime date2) {
    if (date1.day == date2.day) {
      if (date1.month == date2.month) if (date1.year == date2.year) return true;
    } //end if
    return false;
  }
}

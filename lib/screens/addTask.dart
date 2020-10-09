import 'package:flutter/material.dart';
import 'package:peak/enums/taskType.dart';
import 'package:peak/services/notification.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:peak/models/task.dart';

class AddTask extends StatefulWidget {
  var width;
  var height;
  Function showError;
  List<Task> tasks;
  DateTime deadline;
  AddTask(this.tasks, this.width, this.height, this.showError, this.deadline);
  @override
  State<StatefulWidget> createState() => new AddTaskState();
}

class AddTaskState extends State<AddTask> {
  String repetitionError;
  final values = [true, false, false, false, false, false, false];

  DateTime _dateTime;
  DateTime now = DateTime.now();
  String dropdownValue;
  String currentValue;
  String error;
  String updateError;
  List<Widget> tasksList = [];
  TextEditingController _taskcontroller = TextEditingController();
  TextEditingController _updateController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new ListView(
        shrinkWrap: true, physics: ScrollPhysics(), children: tasksList);
  }

  @override
  void initState() {
    super.initState();
    _buildTasks(null);
  }

  List<Widget> _buildTasks(int editIndex) {
    tasksList = [];
    if (editIndex != null) {
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
      print("inside Edit task $editIndex");
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
                        color: Colors.black87,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: _updateController,
                  decoration: InputDecoration(
                    labelText: 'Task Name',
                    errorText: updateError,
                  ),
                  onChanged: (_) {
                    setState(() {
                      if (_updateController.text.isNotEmpty) {
                        updateError = null;
                        _buildTasks(editIndex);
                      } else {}
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  hint: Text("Repetition"),
                  style: TextStyle(
                      color: Color.fromRGBO(23, 23, 85, 1.0), fontSize: 25),
                  value: dropdownValue,
                  onChanged: (newValue) {
                    setState(() {
                      widget.tasks[editIndex].taskName = _updateController.text;
                      _dateTime = DateTime.now();
                      dropdownValue = newValue;
                      currentValue = newValue;
                      _buildTasks(editIndex);
                    });
                  },
                  items: ['Daily', 'Weekly', 'Monthly', 'Once']
                      .map<DropdownMenuItem<String>>((value) {
                    //currentValue = value;
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                repeatDate(index: editIndex),
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
                        color: Colors.black87,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
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
                  onChanged: (_) {
                    setState(() {
                      error = null;
                      _buildTasks(null);
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  hint: Text("Repetition"),
                  style: TextStyle(
                    color: Color.fromRGBO(23, 23, 85, 1.0),
                    fontSize: 25,
                  ),
                  value: dropdownValue,
                  onChanged: (newValue) {
                    setState(() {
                      repetitionError = null;
                      dropdownValue = newValue;
                      currentValue = newValue;
                      _buildTasks(null);
                    });
                  },
                  decoration: InputDecoration(
                    errorText: repetitionError,
                  ),
                  items: ['Daily', 'Weekly', 'Monthly', 'Once']
                      .map<DropdownMenuItem<String>>((value) {
                    //currentValue = value;
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),

                repeatDate(), //add the user selection !!!

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
      if (editIndex != null && editIndex == index) continue;
      var currentTask;
      var currentTaskType = widget.tasks[index].taskType;
      if (currentTaskType == TaskType.monthly) {
        currentTask = widget.tasks[index] as MonthlyTask;
      } else if (currentTaskType == TaskType.once) {
        currentTask = widget.tasks[index] as OnceTask;
      } else if (currentTaskType == TaskType.weekly) {
        currentTask = widget.tasks[index] as WeeklyTask;
      }
      tasksList.add(Card(
        child: Padding(
          padding: EdgeInsets.all(widget.width * 0.008),
          child: ListTile(
            leading: new IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _removeLabelAt(index)),
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
                icon: const Icon(Icons.edit),
                onPressed: () => _editLabelAt(index)),
          ),
        ),
      ));
    }

    return tasksList;
  } //end _buildTasks

  _clearText() {
    setState(() {
      _taskcontroller.clear();
      dropdownValue = "";
      currentValue = "";
      error = null;
      _buildTasks(null);
    });
  }

  _onSave() {
    setState(() {
      if (_taskcontroller.text.trim().isNotEmpty && dropdownValue != null) {
        widget.tasks.add(creatTask(
            taskName: _taskcontroller.text,
            taskType: currentValue.formString()));
        _taskcontroller.clear();
        error = null;
        repetitionError = null;
        dropdownValue = null;
        currentValue = null;
        _dateTime = DateTime.now();
        _buildTasks(null);
      } else {
        if (dropdownValue == null)
          repetitionError = "Task repetition most be selected! ";
        if (_taskcontroller.text.trim().isEmpty) error = 'Enter a name!';
        _buildTasks(null);
      }
    });
  }

  _removeLabelAt(int index) {
    setState(() {
      if (widget.tasks.length > 1) {
        widget.tasks.removeAt(index);
        _buildTasks(null);
      } else {
        widget.showError(
            "Task can not be deleted, goal most have at least one task.");
        //show alert
        //     showDialog(
        //       context: context,
        //       barrierDismissible: true,
        //       builder: (BuildContext context) {
        //   return AlertDialog(
        //     title: Text('Delete Task'),
        //     content: SingleChildScrollView(
        //       child: ListBody(
        //         children: <Widget>[
        //           Text('Task can not be deleted, goal most have at least one task.'),
        //         ],
        //       ),
        //     ),
        //     actions: <Widget>[
        //       TextButton(
        //         child: Text('Approve'),
        //         onPressed: () {
        //           Navigator.of(context).pop();
        //         },
        //       ),
        //     ],
        //   );
        // },
        //       ); // show dialog
      }
    });
  }

  _editLabelAt(index) {
    setState(() {
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
      }

      _buildTasks(index);
    });
  }

  _onUpdateAt(index) {
    setState(() {
      if (_updateController.text.trim().isNotEmpty) {
        widget.tasks.removeAt(index);
        widget.tasks.add(creatTask(
            taskName: _updateController.text,
            taskType: currentValue.formString()));
        dropdownValue = null;
        currentValue = null;
        _updateController.clear();
        _dateTime = DateTime.now();
        updateError = null;
        _buildTasks(null);
      } else {
        updateError = 'Enter a name!';
        _buildTasks(index);
      }
    });
  }

  Widget repeatDate({int index}) {
    if (currentValue == "Daily") {
      return Text("*This task will repeat daily",
          style: TextStyle(
              fontFamily: 'Montserrat', fontSize: 18.0, color: Colors.teal),
          textAlign: TextAlign.center);
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
                  _buildTasks(index);
                }
              });
            },
            values: values,
          )
        ],
      );
    } else if (currentValue == "Monthly") {
      return Column(
        children: [
          Text("*Pick the starting day for your monthly task",
              style: TextStyle(
                  fontFamily: 'Montserrat', fontSize: 18.0, color: Colors.teal),
              textAlign: TextAlign.center),
          CalendarDatePicker(
              initialDate: _dateTime == null ? DateTime.now() : _dateTime,
              firstDate: DateTime.now(),
              lastDate: widget.deadline.subtract(Duration(days: 1)),
              onDateChanged: (d) {
                _dateTime = d;
              })
        ],
      );
    } else if (currentValue == "Once") {
      return CalendarDatePicker(
          initialDate: _dateTime == null ? DateTime.now() : _dateTime,
          firstDate: DateTime.now(),
          lastDate: widget.deadline.subtract(Duration(days: 1)),
          onDateChanged: (d) {
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
        return DailyTask(taskName: taskName);
      case TaskType.once:
        var date = _dateTime == null ? DateTime.now() : _dateTime;
        return OnceTask(taskName: taskName, date: date);
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
        return WeeklyTask(taskName: taskName, weekdays: days);
      case TaskType.monthly:
        var day = _dateTime == null ? DateTime.now().day : _dateTime.day;
        return MonthlyTask(taskName: taskName, day: day);
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
}
import 'package:flutter/material.dart';
import 'package:peak/enums/taskType.dart';
import 'package:peak/models/goal.dart';
import 'package:peak/screens/shared/base.dart';
import 'package:peak/viewmodels/goalDetails_model.dart';
import 'package:provider/provider.dart';
import '../locator.dart';

class GoalDetails extends StatelessWidget {
  Goal goal;
  GoalDetails({this.goal});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider<GoalDetailsModel>(
      create: (context) => locator<GoalDetailsModel>(),
      child: Consumer<GoalDetailsModel>(
        builder: (context, model, child) => Base(
          chidlPadding: EdgeInsets.fromLTRB(width * 0.06, 0, width * 0.06, 0.0),
          title: "Goal Details",
          actions: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () =>
                  Navigator.pushNamed(context, "editGoal", arguments: goal),
            ),
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                onPressed: () async {
                  var isDeleted = await model.deleteGoal(goal);
                  if (isDeleted) {
                    Navigator.pop(context);
                    var deleteDialogResponse =
                        await model.dialogService.showConfirmationDialog(
                      title: 'your Goal was deleted successfully!',
                      description:
                          'Do you want to delete this goal from your Google Calendar?',
                      confirmationTitle: 'Yes',
                      cancelTitle: 'No',
                    );
                    if (deleteDialogResponse.confirmed) {
                      model.deletFromGooleCalendar(goal.docID);
                    }
                  }
                }),
          ],
          child: SingleChildScrollView(
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        title: Text(goal.goalName),
                      ),
                      ListTile(
                        title: Text("Due Date"),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${goal.deadline.day}/${goal.deadline.month}/${goal.deadline.year}"),
                            goalStatus(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(width * 0.02),
                  child: Text(
                    "Tasks",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.06,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: goal.tasks.length,
                    itemBuilder: (context, index) {
                      var currentTask = model.task(goal, index);
                      return Card(
                        child: Padding(
                          padding: EdgeInsets.all(width * 0.008),
                          child: ListTile(
                            title: Text(goal.tasks[index].taskName),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "${goal.tasks[index].taskType.toShortString().substring(0, 1).toUpperCase() + goal.tasks[index].taskType.toShortString().substring(1)} Task" +
                                        ((goal.tasks[index].taskType ==
                                                TaskType.daily)
                                            ? ""
                                            : (goal.tasks[index].taskType ==
                                                    TaskType.monthly
                                                ? " on ${currentTask.day}"
                                                : (goal.tasks[index].taskType ==
                                                        TaskType.once
                                                    ? " on ${currentTask.date.toString().split(" ").first}"
                                                    : " on ${currentTask.weekdaysList()}"))),
                                    softWrap: true,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.assignment_turned_in,
                                      color: Colors.teal,
                                    ),
                                    Text(
                                        "${currentTask.achievedTasks}/${currentTask.taskRepetition}"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                _buildGestureDetector(model, width),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGestureDetector(model, width) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            width * 0.009, width * 0.02, width * 0.009, width * 0.01),
        child: Center(
          child: Text(
            "Add this goal to my Google Calendar",
            style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline)
                .apply(color: Colors.teal),
          ),
        ),
      ),
      onTap: () {
        model.addGoalToGoogleCalendar(
            goal.goalName, goal.creationDate, goal.deadline, goal.docID);
      },
    );
  }

  Widget goalStatus() {
    if (goal.isAchieved) {
      return Row(children: [
        Icon(
          Icons.brightness_1,
          color: (Colors.green),
        ),
        Text("Completed"),
      ]);
    }

    bool today = goal.deadline.day == DateTime.now().day &&
        goal.deadline.month == DateTime.now().month &&
        goal.deadline.year == DateTime.now().year;

    if (goal.deadline.isBefore(DateTime.now()) && !today) {
      return Row(children: [
        Icon(
          Icons.brightness_1,
          color: (Colors.grey),
        ),
        Text("Outdated"),
      ]);
    }

    if (goal.calcProgress() == 0) {
      return Row(
        children: [
          Icon(
            Icons.brightness_1,
            color: (Colors.red),
          ),
          Text("Incomplete"),
        ],
      );
    }

    return Row(
      children: [
        Icon(
          Icons.brightness_1,
          color: (Colors.blue),
        ),
        Text("In progress"),
      ],
    );
  }
}

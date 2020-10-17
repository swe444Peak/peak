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
          title: "Goal Details",
          actions: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () => print(""),
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
                        title: Text("Goal Name"),
                        subtitle: Text(goal.goalName),
                      ),
                      ListTile(
                        title: Text("Due Date"),
                        subtitle: Text(
                            "${goal.deadline.day}/${goal.deadline.month}/${goal.deadline.year}"),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(width * 0.04),
                  child: Text(
                    "Tasks",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.06,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                ListView.builder(
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
                              Text(
                                "${goal.tasks[index].taskType.toShortString()} Task" +
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

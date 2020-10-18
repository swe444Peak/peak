import 'package:flutter/material.dart';
import 'package:peak/enums/taskType.dart';
import 'package:peak/models/goal.dart';
import 'package:peak/models/task.dart';
import 'package:peak/screens/shared/base.dart';
import 'package:peak/viewmodels/goalsList_model.dart';
import 'package:provider/provider.dart';

import '../locator.dart';

class GoalDetails extends StatelessWidget {
  Goal goal;
  GoalDetails({this.goal});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    List<Widget> actions = [
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
        onPressed: () => print(""),
      )
    ];

    return ChangeNotifierProvider<GoalsListModel>(
      create: (context) => locator<GoalsListModel>(),
      child: Consumer<GoalsListModel>(
        builder: (context, model, child) => Base(
          title: "Goal Details",
          actions: actions,
          child: SingleChildScrollView(
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.02),
                    child: ListTile(
                      title: Text("Goal Name"),
                      subtitle: Text(goal.goalName),
                    ),
                  ),
                ),
                Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.02),
                    child: ListTile(
                      title: Text("Due Date"),
                      subtitle: Text(
                          "${goal.deadline.day}/${goal.deadline.month}/${goal.deadline.year}"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

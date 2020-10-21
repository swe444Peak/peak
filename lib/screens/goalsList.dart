import 'package:flutter/material.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/screens/shared/custom_bottomNavigationBar.dart';
import 'package:peak/viewmodels/goalsList_model.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:stacked/stacked.dart';
import '../locator.dart';

class GoalsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return ViewModelBuilder<GoalsListModel>.reactive(
      viewModelBuilder: () => locator<GoalsListModel>(),
      onModelReady: (model) => model.readGoals(),
      builder: (context, model, child) => Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Color.fromRGBO(23, 23, 85, 1.0),
          bottomNavigationBar: CustomNavigationBar(1),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, 'addNewGoal');
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.teal[400],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          body: Stack(
            children: [
              Container(
                width: width * 0.8,
                height: width * 0.6,
                margin: EdgeInsets.fromLTRB(0, 0.0, width * 0.2, 0.0),
                decoration: BoxDecoration(
                    color: Colors.indigo[500],
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(400)),
                    gradient: LinearGradient(colors: [
                      Colors.teal[400],
                      Colors.indigo[600],
                      Colors.deepPurple[900]
                    ], begin: Alignment.topLeft, end: Alignment.bottomCenter)),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                    width * 0.06, height * 0.12, width * 0.06, 0.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              0.0, 0.0, 0.0, (width * 0.06)),
                          child: Text(
                            "Goals List",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Flexible(child: goalsList(model, width, height)),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget goalsList(model, width, height) {
    if (model.state == ViewState.Busy) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (model.empty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            "Your Goals list is empty\n Start adding new Goals!",
            style: TextStyle(fontSize: width * 0.06, color: Colors.white),
          ),
        ),
      );
    }

    if (model.goals != null) {
      return ListView.builder(
        itemCount: model.goals.length,
        itemBuilder: (context, index) {
          var goal = model.goals[index];
          return Card(
            //card Property
            elevation: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),

            child: ListTile(
              contentPadding: EdgeInsets.fromLTRB(
                  width * 0.05, height * 0.02, 0.0, height * 0.01),
              title: Text(
                goal.goalName,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              subtitle: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            0.0, height * 0.008, 0.0, height * 0.008),
                        child: new LinearPercentIndicator(
                          width: width * 0.7,
                          lineHeight: 14.0,
                          percent: goal.calcProgress(),
                          backgroundColor: Colors.indigo[900],
                          progressColor: Colors.blue,
                          center: Text(
                            "${goal.calcProgress() * 100}%",
                            style: new TextStyle(
                                color: Colors.white, fontSize: 12.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        0.0, height * 0.01, 0.0, height * 0.01),
                    child: Row(
                      children: [
                        Container(
                          //due date
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.008),
                          child: Row(
                            children: [
                              Icon(
                                Icons.assistant_photo,
                                color: Colors.amber,
                              ),
                              Text(
                                  "${goal.deadline.day}/${goal.deadline.month}/${goal.deadline.year}"),
                            ],
                          ),
                        ),
                        Container(
                          //Tasks
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.008),
                          child: Row(
                            children: [
                              Icon(
                                Icons.assignment_turned_in,
                                color: Colors.teal,
                              ),
                              Text(
                                  "${goal.calcAchievedTasks()}/${goal.numOfTasks}"),
                            ],
                          ),
                        ),
                        Container(
                          //status
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.01),
                          child: goalStatus(goal),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, "goalDetails", arguments: goal);
              },
            ),
          );
        },
      );
    }
  }

  Widget goalStatus(goal) {
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/viewmodels/home_model.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import '../locator.dart';
import 'shared/custom_bottomNavigationBar.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  int tab = 0; //tabs: 0=>Tasks  1=>completed  2=>Incompleted
  var user;
  var width;
  var height;
  List<Widget> tasks = [];
  int numTasks;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    width = screenSize.width;
    height = screenSize.height;
    var user = Provider.of<User>(context);
    var puser;
    DatabaseServices().userData(user?.uid).listen((event) {
      puser = event;
    });

    return ViewModelBuilder<HomeModel>.reactive(
      viewModelBuilder: () => locator<HomeModel>(),
      onModelReady: (model) => model.readTasks(),
      builder: (context, model, child) => Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Color.fromRGBO(23, 23, 85, 1.0),
          bottomNavigationBar: CustomNavigationBar(0),
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
              ClipPath(
                clipper: WaveClipperOne(),
                child: Container(
                  height: height * 0.24,
                  //margin: EdgeInsets.fromLTRB(0, 0.0, width * 0.2, 0.0),
                  decoration: BoxDecoration(
                      color: Colors.indigo[500],
                      gradient: LinearGradient(
                          colors: [
                            Colors.teal[400],
                            Colors.indigo[600],
                            Colors.deepPurple[900]
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomCenter)),
                ),
              ),
              // Container(
              //   width: width * 0.8,
              //   height: width * 0.6,
              //   margin: EdgeInsets.fromLTRB(0, 0.0, width * 0.2, 0.0),
              //   decoration: BoxDecoration(
              //       color: Colors.indigo[500],
              //       borderRadius:
              //           BorderRadius.only(bottomRight: Radius.circular(400)),
              //       gradient: LinearGradient(colors: [
              //         Colors.teal[400],
              //         Colors.indigo[600],
              //         Colors.deepPurple[900]
              //       ], begin: Alignment.topLeft, end: Alignment.bottomCenter)),
              // ),
              Container(
                padding: EdgeInsets.fromLTRB(
                    width * 0.06, height * 0.07, width * 0.06, 0.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  0.0, 0.0, 0.0, (width * 0.03)),
                              child: Text(
                                ((puser != null) ? ("Hi, "+puser.name[0].toUpperCase() + puser.name.substring(1)+"!") : "Today's Tasks List"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  0.0, 0.0, 0.0, (width * 0.1)),
                              child: Text(
                                ((model.empty || model.tasks.length == 0)?"Oops you have no tasks for today!": (model.incompTasks.length == 0)? 
                                "Wow you finished all your tasks for today!":"Here is your tasks for today, go clear them!"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Flexible(
                      child: (model.state == ViewState.Busy)
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : (model.empty || model.tasks.length == 0)
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      ((!model.empty)? "Will it looks like you have a break for today, have fun!": "Get started by adding some goals so you can have tasks to acheive!"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                )
                              : (model.goals != null)
                                  ? ListView.builder(
                                      itemCount: model.tasks.length,
                                      itemBuilder: (context, index) {
                                        var task = model.tasks[index];
                                        print(model.tasks.length);
                                        return Card(
                                            elevation: 20,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.all(width * 0.008),
                                              child: ListTile(
                                                title: Text(
                                                  task["task"].taskName,
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: (task["status"]
                                                        ? Colors.grey
                                                        : Colors.black87),
                                                    decoration: (task["status"]
                                                        ? TextDecoration
                                                            .lineThrough
                                                        : TextDecoration.none),
                                                  ),
                                                ),
                                                subtitle: Text(task["goal"]),
                                                trailing: IconButton(
                                                    icon: Icon(
                                                      (task["status"]
                                                          ? Icons.check_box
                                                          : Icons
                                                              .check_box_outline_blank),
                                                      color: (task["status"]
                                                          ? Colors.green
                                                          : Colors.grey),
                                                    ),
                                                    onPressed: () {
                                                      if (task["status"]) {
                                                        model.updateTask(
                                                            task["task"],
                                                            task["goalId"],
                                                            task["status"]);
                                                        //initState();
                                                      } else {
                                                        model.updateTask(
                                                            task["task"],
                                                            task["goalId"],
                                                            task["status"]);
                                                        //initState();
                                                      }
                                                    }),
                                              ),
                                            ));
                                      },
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(),
                                    ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  } //end bulid

  @override
  void initState() {
    super.initState();
  }

  void _buildTasks({
    int tab = 0,
  }) {
    HomeModel model = locator<HomeModel>();
    model.readTasks();
    List<Map<String, dynamic>> completed = model.compTasks;
    List<Map<String, dynamic>> incompleted = model.incompTasks;
    numTasks =
        ((completed.isNotEmpty) ? completed.length : 0) + incompleted.length;
    print("num = $numTasks name = ");
    switch (tab) {
      case 0:
        if (completed.isNotEmpty)
          incompleted.forEach((element) {
            tasks.add(Card(
                child: Padding(
              padding: EdgeInsets.all(width * 0.1),
              child: ListTile(
                title: Text(element["task"]),
                subtitle: Text(element["goal"]),
                trailing: IconButton(
                    icon: Icon(
                      Icons.check_box_outline_blank,
                      color: Colors.grey,
                    ),
                    onPressed: () {}),
              ),
            ))); //end add
          }); //end forEach incopmleted
        print("here****************");
        completed.forEach((element) {
          tasks.add(Card(
              child: Padding(
            padding: EdgeInsets.all(width * 0.1),
            child: ListTile(
              title: Text(
                element["task"],
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              subtitle: Text(element["goal"]),
              trailing: IconButton(
                  icon: Icon(
                    Icons.check_box,
                    color: Colors.green,
                  ),
                  onPressed: () {}),
            ),
          ))); //end add
        }); //end forEach copmleted
        break;
      case 1:
      case 2:
    }
  }
}

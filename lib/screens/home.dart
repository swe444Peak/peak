import 'package:flutter/material.dart';
import 'package:peak/viewmodels/home_model.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import '../locator.dart';
import 'shared/custom_bottomNavigationBar.dart';

class HomePage extends StatefulWidget{
  @override
  HomePageState createState() => new HomePageState();

} 
class HomePageState extends State<HomePage>{
    int tab;     //tabs: 0=>Tasks  1=>completed  2=>Incompleted
    var width;
    var height;
    List<Widget> tasks = [];
    int numTasks;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    width = screenSize.width;
    height = screenSize.height;

    return ViewModelBuilder<HomeModel>.reactive(
      viewModelBuilder: () => locator<HomeModel>(),
      onModelReady: (model) {
        model.readTasks();
        _buildTasks(model: model);
      },
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
                    gradient: LinearGradient(colors: [
                      Colors.teal[400],
                      Colors.indigo[600],
                      Colors.deepPurple[900]
                    ], begin: Alignment.topLeft, end: Alignment.bottomCenter)),
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
                                "Hi, ${model.getUser().name[0].toUpperCase()+model.getUser().name.substring(1)}!",
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
                            "Here is your tasks for today, go clear them!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                            
                          ],
                        ),
                        
                      ],
                    ),
                    Flexible(
                      child: (model.empty)
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  "Your Goals list is empty\n Start adding new Goals!",
                                  style: TextStyle(
                                      fontSize: width * 0.06,
                                      color: Colors.white),
                                ),
                              ),
                            )
                          : (model.goals != null)
                              ? ListView(
                                children: tasks)
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
  }//end bulid 

  
  // @override
  // void initState() {
  //   super.initState();
  // }

  void _buildTasks({int tab = 0, HomeModel model}){
    List<Map<String, dynamic>> completed = model.compTasks;
    List<Map<String, dynamic>> incompleted = model.incompTasks;
    numTasks = completed.length + incompleted.length;
    switch(tab){
      case 0:
              incompleted.forEach((element) { 
                tasks.add(Card(
                  child: Padding(
                    padding: EdgeInsets.all(width*0.1),
                    child: ListTile(
                      title: Text(element["task"]),
                      subtitle: Text(element["goal"]),
                      trailing: IconButton(
                        icon: Icon(
                        Icons.check_box_outline_blank,
                        color: Colors.grey,
                      ),
                onPressed: (){}),
                    ),
                )
                )
                );//end add
              });//end forEach incopmleted

              completed.forEach((element) { 
                tasks.add(Card(
                  child: Padding(
                    padding: EdgeInsets.all(width*0.1),
                    child: ListTile(
                      title: Text(element["task"]),
                      subtitle: Text(element["goal"]),
                      trailing: IconButton(
                        icon: Icon(
                        Icons.check_box,
                        color: Colors.green,
                      ),
                onPressed: (){}),
                    ),
                )
                )
                );//end add
              });//end forEach copmleted 
              break;
      case 1:
      case 2:
    }
  }

}

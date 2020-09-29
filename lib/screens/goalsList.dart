import 'package:flutter/material.dart';
import 'package:peak/viewmodels/createGoal_model.dart';
import 'package:peak/models/task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class GoalsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    List<Task> tasks = List<Task>();
    for(int i=1 ; i<=3 ; i++){
    tasks.add(Task("$i", false));
    }
    if(user != null){
    print('it is working !!${CreateGoalModel().createGoal("health", user.uid, DateTime.now(), 3, tasks)}');}
    return Container(
      child: Text("Goals List"));
  }
}

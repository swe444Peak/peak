import 'package:flutter/material.dart';
import 'package:peak/viewmodels/createGoal_model.dart';
import 'package:peak/models/task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:peak/viewmodels/goalsList_model.dart';
import 'package:stacked/stacked.dart';
import '../locator.dart';

class GoalsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GoalsListModel>.reactive(
      viewModelBuilder: () => locator<GoalsListModel>(),
      onModelReady: (model) => model.readGoals(),
      builder: (context, model, child) => Scaffold(
        body: Scaffold(
          body: (model.goals != null)
              ? ListView() //here, the list view is just a templete :), use whatever you like
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}

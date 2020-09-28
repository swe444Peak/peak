import 'package:flutter/cupertino.dart';
import 'package:peak/Models/goal.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/locator.dart';
import 'package:peak/services/databaseServices.dart';

class GoalsListModel extends ChangeNotifier {
  final _firstoreService = locator<DatabaseServices>();
  ViewState _state = ViewState.Idle;
  List<Goal> _goals;

  List<Goal> get goals => _goals;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  void readGoals() {
    setState(ViewState.Busy);
    _firstoreService.getGoals().listen((goalData) {
      List<Goal> updatedGoals = goalData;
      if (updatedGoals != null && updatedGoals.length > 0) {
        _goals = updatedGoals;
        notifyListeners();
      }
      setState(ViewState.Idle);
    });
  }
}

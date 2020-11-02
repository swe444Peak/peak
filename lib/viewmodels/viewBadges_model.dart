import 'package:flutter/cupertino.dart';
import 'package:peak/models/goal.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/locator.dart';
import 'package:peak/services/databaseServices.dart';

class ViewBadgesModel extends ChangeNotifier {
  final _firstoreService = locator<DatabaseServices>();
  ViewState _state = ViewState.Idle;
  List<Goal> _goals;
  bool empty = false;
  int achieved;
  int unachieved;
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
      if (updatedGoals != null) {
        if (updatedGoals.length > 0) {
          empty = false;
          _goals = updatedGoals;
        } else {
          empty = true;
        }
        notifyListeners();
      }
      setState(ViewState.Idle);
    }, onError: (error) => print(error));
  }

  double clacToatlProgress() {
    double progress = 0.0;
    if (_goals != null && goals.length > 0) {
      _goals.forEach((element) {
        progress += element.calcProgress();
      });
      progress = (progress / goals.length) * 100;
    }

    return progress;
  }

  int calcAchieved() {
    achieved = 0;
    unachieved = 0;
    if (_goals == null || _goals.length == 0) {
      unachieved = 0;
      achieved = 0;
      return achieved;
    }

    _goals.forEach((element) {
      if (element.isAchieved)
        achieved++;
      else
        unachieved++;
    });
    return achieved;
  }
}

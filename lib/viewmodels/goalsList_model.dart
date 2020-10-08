import 'package:flutter/cupertino.dart';
import 'package:peak/models/goal.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/locator.dart';
import 'package:peak/services/databaseServices.dart';

class GoalsListModel extends ChangeNotifier {
  final _firstoreService = locator<DatabaseServices>();
  ViewState _state = ViewState.Idle;
  List<Goal> _goals;
  bool empty = false;
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
          sortGoals();
        } else {
          empty = true;
        }
        notifyListeners();
      }
      setState(ViewState.Idle);
    }, onError: (error) => print(error));
  }

  void sortGoals() {
    _goals.sort((a, b) => a.creationDate.compareTo(b.creationDate));
    _goals = _goals.reversed.toList();
  }
}

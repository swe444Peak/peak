import 'package:flutter/material.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/models/compitetor.dart';
import 'package:peak/models/user.dart';
import 'package:peak/models/goal.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/services/firebaseAuthService.dart';

import '../locator.dart';

class CompetitorsProgressModel extends ChangeNotifier {
  final _database = locator<DatabaseServices>();
  List<PeakUser> _users = [];
  ViewState _state = ViewState.Idle;
  List<Goal> _compitetorsGoals = [];
  ViewState get state => _state;
  List<Goal> get compitetorsGs => _compitetorsGoals;
  List<PeakUser> get users => _users;

  List<Compitetor> comps = [];

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  getCompetitorsGoals(competitors) async {
    setState(ViewState.Busy);
    List<Goal> cGoals = await _database.getCertainGoals(competitors);
    _compitetorsGoals = cGoals;

    print(_compitetorsGoals.length);
    List<Compitetor> comss = [];
    for (int i = 0; i < _compitetorsGoals.length; i++) {
      Goal cgoal = _compitetorsGoals[i];
      PeakUser cuser = await getUser(cgoal.uID);

      Compitetor c = Compitetor(cgoal, cuser);
      print(c.user.name);
      comps.add(c);
    }

    setState(ViewState.Idle);
  }

  getUser(uid) async {
    var user = await _database.getUserProfile(uid);
    return user;
  }
}

import 'package:flutter/material.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/models/user.dart';
import 'package:peak/services/databaseServices.dart';

import '../locator.dart';

class AddCompetitorsModel extends ChangeNotifier {
  final _firstoreService = locator<DatabaseServices>();
  ViewState _state = ViewState.Idle;
  bool empty = false;
  List<PeakUser> _friends;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  void readfriendslist() {
    setState(ViewState.Busy);
    _firstoreService.getFriendsids().listen((friendsData) {
      List<PeakUser> friends = friendsData;
      if (friends != null) {
        if (friends.length > 0) {
          print('larger than 0');
          empty = false;
          _friends = friends;
        } else {
          empty = true;
        }
        notifyListeners();
      }
      setState(ViewState.Idle);
    }, onError: (error) => print(error));
  }
}

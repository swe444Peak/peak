import 'package:flutter/material.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/models/friends.dart';
import 'package:peak/models/user.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/services/firebaseAuthService.dart';

import '../locator.dart';

class AddCompetitorsModel extends ChangeNotifier {
  final _firstoreService = locator<DatabaseServices>();
  final _firebaseService = locator<FirbaseAuthService>();
  ViewState _state = ViewState.Idle;
  bool empty = false;
  bool disposed = false;
  List<Friends> competitors;
  List<PeakUser> users;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    if (!disposed) notifyListeners();
  }

  Future<void> readCompetitors() async {
    users = [];
    // List<String> friendsuids = [];
    // setState(ViewState.Busy);

    // _firstoreService.getFriendsids().listen((friendsData) {
    //   List<PeakUser> friends = friendsData;
    //   if (friends != null) {
    //     if (friends.length > 0) {
    //       print('larger than 0');
    //       empty = false;
    //       users = friends;
    //       print(users[0].name);
    //       print(users.length);
    //     } else {
    //       empty = true;
    //     }
    //     if (!disposed) notifyListeners();
    //   }
    //   setState(ViewState.Idle);
    // }, onError: (error) => print(error));
    setState(ViewState.Busy);
    List<PeakUser> updatedUsers = await _firstoreService.getCompetitors();
    if (updatedUsers.length > 0) {
      empty = false;
      users = updatedUsers;
    } else
      empty = true;
    setState(ViewState.Idle);
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}

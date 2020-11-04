import 'package:flutter/cupertino.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/models/friends.dart';
import 'package:peak/models/user.dart';
import 'package:peak/services/databaseServices.dart';

import '../locator.dart';

class FriendsListModel extends ChangeNotifier {
  final _firstoreService = locator<DatabaseServices>();
  ViewState _state = ViewState.Idle;
  bool empty = false;

  List<PeakUser> _friends = [];

  ViewState get state => _state;
  List<PeakUser> get friends => _friends;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

/*
  readfriendsist() {
    Future.delayed(Duration(seconds: 5));
    getFriendsData();
    notifyListeners();
    setState(ViewState.Idle);
  }
*/

  readfriendslist() {
    setState(ViewState.Busy);
    _firstoreService.getFriendsids().listen((friendsData) {
      List<PeakUser> friends = friendsData;
      if (friends != null) {
        if (friends.length > 0) {
          print('larger than 0');
          empty = false;
          _friends = friends;
          print(_friends[0].name);
          print(_friends.length);
        } else {
          empty = true;
        }
        notifyListeners();
      }
      setState(ViewState.Idle);
    }, onError: (error) => print(error));
  }
/*
  getFriendsData() {
    print("in hereeeeee");
    for (int i = 0; i < _ids.length; i++) {
      print(_ids[i]);
      var friend = _firstoreService.getUserProfile(_ids[i]);
      _friends.add(friend);
    }
  }
  */
}

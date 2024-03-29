import 'package:flutter/material.dart';
import 'package:peak/models/friends.dart';
import 'package:peak/models/user.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/models/validationItem.dart';
import 'package:peak/services/databaseServices.dart';

import '../locator.dart';

class SearchForFriendModel extends ChangeNotifier {
  
  final _firstoreService = locator<DatabaseServices>();
  ViewState _state = ViewState.Idle;
  List<PeakUser> _usersList = [];
  bool _isTheyFriends = false;
  bool empty = false;
  ViewState get state => _state;
  List<PeakUser> get users => _usersList;
  bool get isTheyFriends => _isTheyFriends;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  Future<bool> isFriends(String uid1, String uid2) async {
    _isTheyFriends = await _firstoreService.isFriends(uid1, uid2);
    return _isTheyFriends;
  }

  readSearchedlist() async {
    _firstoreService.getAllUsers().listen((searchedData) {
      List<PeakUser> searchedUser = searchedData;
      if (searchedUser != null) {
        if (searchedUser.length > 0) {
          empty = false;
          _usersList = searchedUser;
          //   sortUsers();
        } else {
          empty = true;
        }
        notifyListeners();
      }
      setState(ViewState.Idle);
    }, onError: (error) => print(error));
  }

  void sortUsers() {
    _usersList.sort((a, b) => a.name.compareTo(b.name));
    _usersList = _usersList.reversed.toList();
  }

  addFriend(friendId, currentId) {
    Friends friendship = Friends(userid1: currentId, userid2: friendId);
    _firstoreService.addFriendship(friendship);
  }
}

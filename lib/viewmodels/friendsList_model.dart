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

  readfriendslist() async {
    setState(ViewState.Busy);

    List<String> fIDs = await _firstoreService.getFriendsids();

    print("heree $fIDs.length");
    if (fIDs.length > 0) {
      print('larger than 0');
      empty = false;
      getFriendsData(fIDs);
    } else {
      print(fIDs.length);
      empty = true;
    }
    notifyListeners();
    setState(ViewState.Idle);
  }

  getFriendsData(List<String> ids) async {
    print("in hereeeeee");
    for (int i = 0; i < ids.length; i++) {
      print(ids[i]);
      _friends.add(await _firstoreService.getUserProfile(ids[i]));
    }
    print(_friends[0]);
  }
}

import 'package:flutter/cupertino.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/models/user.dart';

class FriendsListModel extends ChangeNotifier {
  ViewState _state = ViewState.Idle;
  bool empty = true;
  List<PeakUser> _friends;

  ViewState get state => _state;
  List<PeakUser> get friends => _friends;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  readflist() {
    setState(ViewState.Idle);
  }
}

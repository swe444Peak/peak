import 'package:flutter/cupertino.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/models/user.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/services/dialogService.dart';

import '../locator.dart';

class FriendsListModel extends ChangeNotifier {
  final _firstoreService = locator<DatabaseServices>();
  DialogService dialogService = locator<DialogService>();
  ViewState _state = ViewState.Idle;
  bool empty = false;
  bool disposed = false;
  List<PeakUser> _friends = [];

  ViewState get state => _state;
  List<PeakUser> get friends => _friends;

  void setState(ViewState viewState) {
    _state = viewState;
    if (!disposed) notifyListeners();
  }

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
        if (!disposed) notifyListeners();
      }
      setState(ViewState.Idle);
    }, onError: (error) => print(error));
  }

  ///// I wrote here
  Future<bool> deleteFriend(String current, String fid) async {
    var dialogResponse = await dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete this friend?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );
    if (dialogResponse.confirmed) {
      setState(ViewState.Busy);
      await _firstoreService.deleteFriend(fid);
      //await _firstoreService.deleteFriend3(docID);
      setState(ViewState.Idle);
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}

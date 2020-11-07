import 'package:flutter/cupertino.dart';
import 'package:peak/models/badges.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/locator.dart';
import 'package:peak/services/databaseServices.dart';

class ViewBadgesModel extends ChangeNotifier {
  final _firstoreService = locator<DatabaseServices>();
  ViewState _state = ViewState.Idle;
  List<Badge> _badges;
  List<Badge> get badges => _badges;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  void readBadges() {
    setState(ViewState.Busy);
    _firstoreService.userData().listen((userData) {
      List<Badge> updatedBadges = userData.badges;
      if (updatedBadges != null) {
        _badges = updatedBadges;
        notifyListeners();
      }
      setState(ViewState.Idle);
    }, onError: (error) => print(error));
  }

  
}

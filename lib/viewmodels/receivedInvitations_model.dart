import 'package:flutter/material.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/services/databaseServices.dart';

import '../locator.dart';

class ReceivedInvitationsModel extends ChangeNotifier {
  final _firstoreService = locator<DatabaseServices>();
  ViewState _state = ViewState.Idle;

  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }
}

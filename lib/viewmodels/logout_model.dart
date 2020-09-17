import 'package:flutter/material.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/locator.dart';
import 'package:peak/services/firebaseAuthService.dart';

class LogoutMaodel extends ChangeNotifier {
  final FirbaseAuthService _firbaseAuthService = locator<FirbaseAuthService>();

  ViewState _state = ViewState.Idle;

  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  Future logout() async {
    setState(ViewState.Busy);
    var result = await _firbaseAuthService.logout();
    setState(ViewState.Idle);
    return result;
  }
}
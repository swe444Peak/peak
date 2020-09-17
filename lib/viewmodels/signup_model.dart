import 'package:flutter/material.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/services/firebaseAuthService.dart';

import '../locator.dart';

class SignUpMaodel extends ChangeNotifier {
  final FirbaseAuthService _firbaseAuthService = locator<FirbaseAuthService>();

  ViewState _state = ViewState.Idle;

  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  Future signUp(String username, String email, String password) async {
    setState(ViewState.Busy);
    var result = await _firbaseAuthService.signUp(username, email, password);
    setState(ViewState.Idle);
    return result;
  }
}

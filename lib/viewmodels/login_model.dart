import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:peak/Models/validationItem.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/locator.dart';
import 'package:peak/services/firebaseAuthService.dart';

class LoginModel extends ChangeNotifier {
  final FirbaseAuthService _firbaseAuthService = locator<FirbaseAuthService>();
  ValidationItem _email = ValidationItem(null, null);
  ValidationItem _password = ValidationItem(null, null);
  ViewState _state = ViewState.Idle;

  ValidationItem get email => _email;
  ValidationItem get password => _password;
  bool get isValid => email.value != null && password.value != null;
  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  void setEmail(String email) {
    if (email.trim().isEmpty) {
      _email = ValidationItem(null, "Please enter your email address");
    } else {
      if (EmailValidator.validate(email)) {
        _email = ValidationItem(email, null);
      } else {
        _email = ValidationItem(null, "enter a valid email address");
      }
    }
    notifyListeners();
  }

  void setPassword(String password) {
    if (password.isEmpty) {
      _password = ValidationItem(null, "password is required");
    } else {
      _password = ValidationItem(password, null);
    }
    notifyListeners();
  }

  Future login(String email, String password) async {
    setState(ViewState.Busy);
    var result = await _firbaseAuthService.logIn(email, password);
    setState(ViewState.Idle);
    return result;
  }

   Future forgetPassword(String email) async {
    setState(ViewState.Busy);
    var result = await _firbaseAuthService.forgetPassword(email);
    setState(ViewState.Idle);
    return result;
  }

}

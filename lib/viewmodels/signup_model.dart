import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:peak/Models/validationItem.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/services/firebaseAuthService.dart';

import '../locator.dart';

class SignUpModel extends ChangeNotifier {
  final FirbaseAuthService _firbaseAuthService = locator<FirbaseAuthService>();

  ValidationItem _name = ValidationItem(null, null);
  ValidationItem _email = ValidationItem(null, null);
  ValidationItem _password = ValidationItem(null, null);
  ValidationItem _confirmPassword = ValidationItem(null, null);

  ViewState _state = ViewState.Idle;

  //Getters
  ValidationItem get name => _name;
  ValidationItem get email => _email;
  ValidationItem get password => _password;
  ValidationItem get confirmPassword => _confirmPassword;
  bool get isValid =>
      name.value != null &&
      email.value != null &&
      password.value != null &&
      confirmPassword.value != null;

  ViewState get state => _state;

  void setName(String name) {
    if (name.trim().isEmpty) {
      _name = ValidationItem(null, "please enter your name");
    } else {
      _name = ValidationItem(name, null);
    }
    notifyListeners();
  }

  void setEmail(String email) {
    if (email.trim().isEmpty) {
      _email = ValidationItem(null, "email is required");
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
      if (password.length <= 8) {
        _password =
            ValidationItem(null, "password must be at least 8 characters long");
      } else {
        if (!validatePassword(password)) {
          _password = ValidationItem(null, "invalid");
        } else {
          _password = ValidationItem(password, null);
          if (_confirmPassword.value != null) {
            if (_confirmPassword.value != password) {
              _confirmPassword = ValidationItem(null, "passwords don\'t match");
            }
          }
        }
      }
    }
    notifyListeners();
  }

  bool validatePassword(String value) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }

  void setConfirmPassword(String confirmPassword) {
    if (confirmPassword.isEmpty) {
      _confirmPassword = ValidationItem(null, "confirm password is required");
    } else {
      if (confirmPassword == password.value) {
        _confirmPassword = ValidationItem(confirmPassword, null);
      } else {
        _confirmPassword = ValidationItem(null, "passwords don\'t match");
      }
    }
    notifyListeners();
  }

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

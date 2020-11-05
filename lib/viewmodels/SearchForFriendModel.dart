import 'package:flutter/material.dart';
import 'package:peak/models/user.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/models/validationItem.dart';
import 'package:peak/services/databaseServices.dart';

import '../locator.dart';

class SearchForFriendModel extends ChangeNotifier {
   final _firstoreService = locator<DatabaseServices>();
  ViewState _state = ViewState.Idle;
  List<PeakUser> _usersList=[];
  bool empty= false;
  ViewState get state => _state;
  List<PeakUser> get users => _usersList;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  readSearchedlist() async {
    _firstoreService.getUsers().listen((searchedData){

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
    setState(ViewState.Idle);}
    , onError: (error) => print(error));
  }
 void sortUsers() {
    _usersList.sort((a, b) => a.name.compareTo(b.name));
    _usersList = _usersList.reversed.toList();
  }

  
}

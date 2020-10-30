import 'package:flutter/material.dart';
import 'package:peak/Models/user.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/models/validationItem.dart';


class SearchForFriendModel extends ChangeNotifier {

 List<PeakUser> _usersList;

 List<PeakUser> get users => _usersList;



}
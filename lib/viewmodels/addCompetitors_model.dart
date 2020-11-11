import 'package:flutter/material.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/models/friends.dart';
import 'package:peak/models/user.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/services/firebaseAuthService.dart';

import '../locator.dart';

class AddCompetitorsModel extends ChangeNotifier {
  final _firstoreService = locator<DatabaseServices>();
  final _firebaseService = locator<FirbaseAuthService>();
  ViewState _state = ViewState.Idle;
  bool empty = false;
  List<Friends> competitors;
  List<PeakUser> users;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  void readCompetitors() {
    users = [];
    List<String> friendsuids = [];
    setState(ViewState.Busy);
    // _firstoreService.getCompetitors().listen((competitorsData) async {
    //   List<Friends> updatedCompetitors = competitorsData;
    //   if (updatedCompetitors != null) {
    //     if (updatedCompetitors.length > 0) {
    //       empty = false;
    //       competitors = updatedCompetitors;

    //       String uid = _firebaseService.currentUser.uid;
    //       competitors.forEach((element) async {
    //         if (friendsuids.length < 10) {
    //           if (element.userid1 != uid)
    //             friendsuids.add(element.userid1);
    //           else
    //             friendsuids.add(element.userid2);
    //         } else {
    //           List<PeakUser> fetchedUsers =
    //               await _firstoreService.getUsers(friendsuids);
    //           users.addAll(fetchedUsers);
    //           friendsuids = [];
    //         }
    //       });

    //       if (users.isEmpty) {
    //         List<PeakUser> fetchedUsers =
    //             await _firstoreService.getUsers(friendsuids);
    //         users.addAll(fetchedUsers);
    //       }
    //     } else {
    //       empty = true;
    //     }
    //     notifyListeners();
    //   }
    //   setState(ViewState.Idle);
    // }, onError: (error) => print(error));

  _firstoreService.getFriendsids().listen((friendsData) {
      List<PeakUser> friends = friendsData;
      if (friends != null) {
        if (friends.length > 0) {
          print('larger than 0');
          empty = false;
          users = friends;
          print(users[0].name);
          print(users.length);
        } else {
          empty = true;
        }
        notifyListeners();
      }
      setState(ViewState.Idle);
    }, onError: (error) => print(error));
  }


  
}

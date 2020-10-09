import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peak/models/goal.dart';
import 'package:peak/locator.dart';
import 'package:peak/models/user.dart';
import 'firebaseAuthService.dart';

class DatabaseServices {
  final String uid;
  DatabaseServices({this.uid});
  final StreamController<List<Goal>> _goalController =
      StreamController<List<Goal>>.broadcast();
  final _firebaseService = locator<FirbaseAuthService>();

  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final _goalsCollectionReference =
      FirebaseFirestore.instance.collection("goals");
  

  Future updateUserData({String username}) async {
    return await userCollection.doc(uid).set({
      "username": username,
      "notificationStatus": true
    });
  } //end updateUserData

  Future updateNotificationStatus({bool status}) async {
     if (_firebaseService.currentUser != null) {
    return await userCollection.doc(_firebaseService.currentUser.uid).update({
      "notificationStatus": status,
    });
     }
  } //end updateUserData
  

  Future updateGoal({Goal goal}) async {
    var doc;
    try {
      doc = await _goalsCollectionReference.add(goal.toMap());
      return doc;
    } catch (e) {
      print("$e");
      return e.toString();
    }
  }

  //creating user data stream to get user doc

  Stream<PeakUser> userData(String id) {
    return userCollection
        .doc(id)
        .snapshots()
        .map((event) => _userDataFromSnapshot(event));
  }

  //extract user data from snapshot

  PeakUser _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return PeakUser(
      uid: snapshot.id,
      name: snapshot.data()['username'],
      notificationStatus : snapshot.data()['notificationStatus']
    );
  }

  Stream getGoals() {
    if (_firebaseService.currentUser != null) {
      _goalsCollectionReference
          .where("uID", isEqualTo: _firebaseService.currentUser.uid)
          .snapshots()
          .listen((goalsSnapshots) {
        if (goalsSnapshots.docs.isNotEmpty) {
          var goals = goalsSnapshots.docs
              .map((snapshot) => Goal.fromJson(snapshot.data(), snapshot.id))
              .toList();
          _goalController.add(goals);
        } else {
          _goalController.add(List<Goal>());
        }
      });
    }

    return _goalController.stream;
  }
}

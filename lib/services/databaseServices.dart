import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peak/models/friends.dart';
import 'package:peak/models/goal.dart';
import 'package:peak/locator.dart';
import 'package:peak/models/task.dart';
import 'package:peak/models/user.dart';

import 'firebaseAuthService.dart';

class DatabaseServices {
  final String uid;
  var peakuser;
  String eventId;
  String eventDoc;
  DatabaseServices({this.uid});
  final StreamController<List<Goal>> _goalController =
      StreamController<List<Goal>>.broadcast();
  final _firebaseService = locator<FirbaseAuthService>();

  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final _goalsCollectionReference =
      FirebaseFirestore.instance.collection("goals");

  final _friendsCollection = FirebaseFirestore.instance.collection("friends");

  Future updateUserData({String username, String picURL}) async {
    return await userCollection.doc(uid).set({
      "username": username,
      "picURL": picURL,
      // "notificationStatus": true
    });
  } //end updateUserData

  /*Future updateNotificationStatus({bool status}) async {
     if (_firebaseService.currentUser != null) {
    return await userCollection.doc(_firebaseService.currentUser.uid).update({
      "notificationStatus": status,
    });
     }
  } //end updateUserData*/

  Future addGoal({Goal goal}) async {
    DocumentReference doc;
    try {
      doc = await _goalsCollectionReference.add(goal.toMap());
      eventDoc = doc.id;
      return doc.id;
    } catch (e) {
      print("$e");
      return e.toString();
    }
  }

  Future updateGoal(Goal goal) async {
    await _goalsCollectionReference
        .doc(goal.docID)
        .update(goal.updateToMap())
        .catchError((error) {
      print(error);
    });
  }

  Future updateEventId(String result) async {
    print("BEFORE UPDATE");
    print(result);
    await _goalsCollectionReference.doc(result).update({
      "eventId": eventId,
    });
  }

  // Future updateEventId()async{

  // }
  //creating user data stream to get user doc

  Stream<PeakUser> userData([String id]) {
    id = _firebaseService.currentUser.uid;
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
      picURL: snapshot.data()['picURL'],
      //  notificationStatus : snapshot.data()['notificationStatus']
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

  Future<List<String>> getFriendsids() {
    List<String> friends = [];

    if (_firebaseService.currentUser != null) {
      _friendsCollection
          .where("userid1", isEqualTo: _firebaseService.currentUser.uid)
          .snapshots()
          .listen((friendsSnapshots) {
        if (friendsSnapshots.docs.isNotEmpty) {
          print('in not empty 1');
          friends = friendsSnapshots.docs
              .map((snapshot) => Friends.getid2(snapshot.data()))
              .toList();
          print(friends.length);
        }
      });

      _friendsCollection
          .where("userid2", isEqualTo: _firebaseService.currentUser.uid)
          .snapshots()
          .listen((friendsSnapshots) {
        if (friendsSnapshots.docs.isNotEmpty) {
          print('in not empty 2');
          var list2 = friendsSnapshots.docs
              .map((snapshot) => Friends.getid1(snapshot.data()))
              .toList();
          friends.addAll(list2);
          print(friends.length);
        }
        print("after");
        print(friends.length);
        return friends;
      });
    }
    print('delay');
    return Future.delayed(Duration(seconds: 5), () => friends);
  }

  Future<PeakUser> getUserProfile(String id) {
    PeakUser user;
    print("here");
    if (_firebaseService.currentUser != null) {
      print("not null");
      userCollection.doc(id).snapshots().listen((usersSnapshots) {
        var snapshot = usersSnapshots.data();
        user = new PeakUser(
            uid: id, name: snapshot["username"], picURL: snapshot["picURL"]);
        print("holllaa");
        return user;
      });
    }
    print('delay2');
    return Future.delayed(Duration(seconds: 5), () => user);
  }

  Future updateAccountData(name) async {
    return await userCollection.doc(_firebaseService.currentUser.uid).update({
      "username": name,
    });
  }

  Future updateProfilePic(picURL) async {
    return await userCollection.doc(_firebaseService.currentUser.uid).update({
      "picURL": picURL,
    });
  }

  Future updateTask(
      String docId, dynamic orignalTask, dynamic editedTask) async {
    await _goalsCollectionReference.doc(docId).update({
      "tasks": FieldValue.arrayRemove([orignalTask.toMap()])
    });

    await _goalsCollectionReference.doc(docId).update({
      "tasks": FieldValue.arrayUnion([editedTask.toMap()])
    });
  }

  Future deleteGoal(String documentId) async {
    await _goalsCollectionReference.doc(documentId).delete();
  }

  PeakUser getUser() {
    userData().listen((event) async {
      peakuser = event;
    });
    while (peakuser != null) {
      return peakuser;
    }
    print("problem in getUser");
    return null;
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peak/models/Invitation.dart';
import 'package:peak/models/friends.dart';
import 'package:peak/models/goal.dart';
import 'package:peak/locator.dart';

import 'package:peak/enums/InvationStatus.dart';
import 'package:peak/models/user.dart';
import 'firebaseAuthService.dart';

class DatabaseServices {
  final String uid;
  var peakuser;
  String eventId;
  String eventDoc;
  DatabaseServices({this.uid});

  final StreamController<List<String>> _idsController =
      StreamController<List<String>>.broadcast();
  final StreamController<List<PeakUser>> _friendsController =
      StreamController<List<PeakUser>>.broadcast();
  final _firebaseService = locator<FirbaseAuthService>();

  final StreamController<List<PeakUser>> _userController =
      StreamController<List<PeakUser>>.broadcast();

  //collection reference
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  CollectionReference _goalsCollectionReference =
      FirebaseFirestore.instance.collection("goals");

  CollectionReference invationsCollection =
      FirebaseFirestore.instance.collection("invations");
  CollectionReference _friendsCollection =
      FirebaseFirestore.instance.collection("friends");

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

  Stream<PeakUser> userData([String id]) {
    if (id.isEmpty) id = _firebaseService.currentUser.uid;
    return userCollection
        .doc(id)
        .snapshots()
        .map((event) => _userDataFromSnapshot(event));
  }

  PeakUser _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return PeakUser(
      uid: snapshot.id,
      name: snapshot.data()['username'],
      picURL: snapshot.data()['picURL'],
      //  notificationStatus : snapshot.data()['notificationStatus']
    );
  }

  Stream getGoals() {
    StreamController<List<Goal>> _goalController =
        StreamController<List<Goal>>.broadcast();
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

  Stream getAllUsers() {
    userCollection.snapshots().listen((usersSs) {
      if (usersSs.docs.isNotEmpty) {
        var users = usersSs.docs
            .map((snapshot) => PeakUser.fromJson(snapshot.data(), snapshot.id))
            .toList();
        _userController.add(users);
      } else {
        _userController.add(List<PeakUser>());
      }
    });
    return _userController.stream;
  }

  List<String> friendsids;
  Stream getFriendsids() {
    friendsids = [];
    if (_firebaseService.currentUser != null) {
      _friendsCollection
          .where("userid1", isEqualTo: _firebaseService.currentUser.uid)
          .snapshots()
          .listen((friendsSnapshots) {
        if (friendsSnapshots.docs.isNotEmpty) {
          print('in not empty 1');
          var friends1 = friendsSnapshots.docs
              .map((snapshot) => Friends.getid2(snapshot.data()))
              .toList();
          if (friends1 != null) {
            friendsids.addAll(friends1);
            print('in 1');
            print(friends1.length);
          }
        }

        futurething2();
        Timer(Duration(seconds: 1), () {
          print("add to controller");
          futurething(friendsids);
        });
      });
    }
    return _friendsController.stream;
  }

  futurething2() {
    _friendsCollection
        .where("userid2", isEqualTo: _firebaseService.currentUser.uid)
        .snapshots()
        .listen((friendsSnapshots) {
      if (friendsSnapshots.docs.isNotEmpty) {
        print('in not empty 2');
        var friends2 = friendsSnapshots.docs
            .map((snapshot) => Friends.getid1(snapshot.data()))
            .toList();
        if (friends2 != null) {
          friendsids.addAll(friends2);
          print('in 2');
          print(friends2.length);
        }
      }
    });
  }

  futurething(friendsids) async {
    List<PeakUser> users = [];
    for (int i = 0; i < friendsids.length; i++) {
      print(friendsids[i]);
      PeakUser user = await getUserProfile(friendsids[i]);
      users.add(user);
    }
    _friendsController.add(users);
  }

  getUserProfile(String id) async {
    var user;
    await userCollection.doc(id).get().then((docRef) {
      var userdata = docRef.data();
      user = new PeakUser(
          uid: id, name: userdata["username"], picURL: userdata["picURL"]);
    });
    print("returning user");
    print(user.name);
    print(user.picURL);
    return user;
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

  Future<bool> isFriends(String uid1, String uid2) async {
    bool fr = false;
    await _friendsCollection
        .where('userid1', isEqualTo: uid1)
        .where('userid2', isEqualTo: uid2)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) fr = true;
    });
    if (!fr) {
      await _friendsCollection
          .where('userid1', isEqualTo: uid2)
          .where('userid2', isEqualTo: uid1)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) fr = true;
      });
    }

    return fr;
  }

  Future inviteFriends(List<Invitation> invations, Goal goal) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    try {
      DocumentReference goalDocReference = _goalsCollectionReference.doc();
      invations.forEach((invation) {
        invation.creatorgoalDocId = goalDocReference.id;
      });

      batch.set(goalDocReference, goal.toMap()); //add goal

      invations.forEach((invation) {
        DocumentReference invationDocReference = invationsCollection.doc();
        batch.set(invationDocReference, invation.toMap()); //invite all friends
      });

      batch.commit();
      return true;
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future acceptGoalInvite(Invitation invation) async {
    DocumentReference goalDocRef =
        _goalsCollectionReference.doc(invation.creatorgoalDocId);
    DocumentReference invationDocRef =
        invationsCollection.doc(invation.invationDocId);
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(goalDocRef);
        Goal goal = Goal.fromJson(snapshot.data(), snapshot.id);

        transaction.update(
            invationDocRef, {"status": invation.status.toShortString()});

        Goal newGoal = Goal(
            goalName: goal.goalName,
            uID: invation.receiverId,
            deadline: goal.deadline,
            tasks: goal.tasks,
            creationDate: goal.creationDate,
            numOfTasks: goal.numOfTasks,
            competitors: goal.competitors);

        DocumentReference newGoalDocRef = _goalsCollectionReference.doc();
        newGoal.competitors.add(newGoalDocRef.id);
        dynamic id = newGoalDocRef.id;

        goal.competitors.forEach((element) {
          DocumentReference goalRef = _goalsCollectionReference.doc(element);
          transaction
              .update(goalRef, {"competitors": FieldValue.arrayUnion(id)});
        });

        transaction.set(newGoalDocRef, newGoal.toMap());
      });
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future declinedGoalInvite(Invitation invation) async {
    try {
      await invationsCollection
          .doc(invation.invationDocId)
          .update({"status": invation.status.toShortString()});
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Stream getReceivedInvations() {
    StreamController<List<Invitation>> invationsController =
        StreamController<List<Invitation>>.broadcast();
    if (_firebaseService.currentUser != null) {
      invationsCollection
          .where("receiverId", isEqualTo: _firebaseService.currentUser.uid)
          .snapshots()
          .listen((invationsSnapshots) {
        if (invationsSnapshots.docs.isNotEmpty) {
          var invations = invationsSnapshots.docs
              .map((snapshot) =>
                  Invitation.fromJson(snapshot.data(), snapshot.id))
              .toList();
          invationsController.add(invations);
        } else {
          invationsController.add(List<Invitation>());
        }
      });
    }

    return invationsController.stream;
  }

  Stream getSentInvations() {
    StreamController<List<Invation>> invationsController =
        StreamController<List<Invation>>.broadcast();
    if (_firebaseService.currentUser != null) {
      invationsCollection
          .where("creatorId", isEqualTo: _firebaseService.currentUser.uid)
          .snapshots()
          .listen((invationsSnapshots) {
        if (invationsSnapshots.docs.isNotEmpty) {
          var invations = invationsSnapshots.docs
              .map(
                  (snapshot) => Invation.fromJson(snapshot.data(), snapshot.id))
              .toList();
          invationsController.add(invations);
        } else {
          invationsController.add(List<Invation>());
        }
      });
    }

    return invationsController.stream;
  }

  Future addFriendship(Friends friends) async {
    var doc = await _friendsCollection.add(friends.toMap());
  }

  Future deleteFriend(String uid1, String uid2) async {
    String docID = '';
    bool found = false;
    if (_firebaseService.currentUser != null) {
      _friendsCollection
          .where("userid1", isEqualTo: uid1)
          .snapshots()
          .listen((friendsSnapshots) async {
        if (friendsSnapshots.docs.isNotEmpty) {
          print('in not empty 1');
          var friends1 = friendsSnapshots.docs
              .map((snapshot) => Friends.delGetid(snapshot.data(), snapshot.id))
              .toList();
          if (friends1 != null) {
            for (int i = 0; i < friends1.length; i++) {
              if (friends1[i].userid2 == uid2) {
                found = true;
                docID = friends1[i].docID;
                break;
              }
            } // loop
          }
        }
        if (!found) {
          deleteFriend2(uid1, uid2);
        } else {
          await _friendsCollection.doc(docID).delete();
        }
      } // listen
              );
    }
  }

  Future deleteFriend2(String uid1, String uid2) async {
    ///// baaaaack

    String docID = '';
    if (_firebaseService.currentUser != null) {
      _friendsCollection
          .where("userid1", isEqualTo: uid2)
          .snapshots()
          .listen((friendsSnapshots) async {
        if (friendsSnapshots.docs.isNotEmpty) {
          print('in not empty 2');
          var friends = friendsSnapshots.docs
              .map((snapshot) => Friends.delGetid(snapshot.data(), snapshot.id))
              .toList();
          if (friends != null) {
            for (int i = 0; i < friends.length; i++) {
              if (friends[i].userid2 == uid1) {
                docID = friends[i].docID;
                break;
              }
            } // loop
          }
        }

        await _friendsCollection.doc(docID).delete();
      } // listen
              );
    }
  }
}

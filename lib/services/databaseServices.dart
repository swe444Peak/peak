import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peak/models/Invitation.dart';
import 'package:peak/models/friends.dart';
import 'package:peak/models/goal.dart';
import 'package:peak/locator.dart';

import 'package:peak/enums/InvationStatus.dart';
import 'package:peak/models/user.dart';
import 'firebaseAuthService.dart';
import 'package:peak/models/badges.dart';

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

  Future updateUserData(
      {String username,
      String picURL,
      List<Map<String, dynamic>> badges}) async {
    return await userCollection.doc(uid).set({
      "username": username,
      "picURL": picURL,
      "badges": badges,
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
    if (goal.competitors == null) {
      await _goalsCollectionReference
          .doc(goal.docID)
          .update(goal.updateToMap())
          .catchError((error) {
        print(error);
      });
    } else {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      try {
        List<String> invIDs = [];
        await invationsCollection
            .where("creatorgoalDocId", isEqualTo: goal.docID)
            .get()
            .then((value) => value.docs.forEach((element) {
                  invIDs.add(element.id);
                }));
        print(invIDs);

        goal.competitors.forEach((element) {
          DocumentReference goalDocReference =
              _goalsCollectionReference.doc(element);
          batch.update(goalDocReference, goal.updateToMap());
        });

        invIDs.forEach((element) {
          DocumentReference invDocReference = invationsCollection.doc(element);
          print(element);
          batch.update(invDocReference, {
            "goalName": goal.goalName,
            "goalDueDate": goal.deadline,
            "numOfTasks": goal.numOfTasks,
          });
        });
        batch.commit();
      } catch (e) {
        print(e);
        return e.toString();
      }
    }
  }

  Future updateEventId(String result) async {
    print("BEFORE UPDATE");
    print(result);
    await _goalsCollectionReference.doc(result).update({
      "eventId": eventId,
    });
  }

  Stream<PeakUser> userData([String id]) {
    id = _firebaseService.currentUser.uid;
    return userCollection
        .doc(id)
        .snapshots()
        .map((event) => _userDataFromSnapshot(event));
  }

  PeakUser _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return PeakUser.fromJson(snapshot.data(), snapshot.id);
  }

  Future<List<PeakUser>> getUsers(List<String> uids) async {
    List<PeakUser> users = [];
    try {
      await userCollection
          .where(FieldPath.documentId, whereIn: uids)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          users = value.docs
              .map(
                  (snapshot) => PeakUser.fromJson(snapshot.data(), snapshot.id))
              .toList();
        }
      });
      return users;
    } catch (e) {
      return null;
    }
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
  List<Friends> friendslist;
  Stream getFriendsids() {
    friendsids = [];
    friendslist = [];
    if (_firebaseService.currentUser != null) {
      _friendsCollection
          .where("userid1", isEqualTo: _firebaseService.currentUser.uid)
          .snapshots()
          .listen((friendsSnapshots) {
        if (friendsSnapshots.docs.isNotEmpty) {
          print('in not empty 1');
          var friends1 = friendsSnapshots.docs
              .map((snapshot) => Friends.fromJson(snapshot.data(), snapshot.id))
              .toList();
          if (friends1 != null) {
            for (int i = 0; i < friends1.length; i++) {
              friendsids.add(friends1[i].userid2);
            }
            friendslist.addAll(friends1);
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
            .map((snapshot) => Friends.fromJson(snapshot.data(), snapshot.id))
            .toList();
        if (friends2 != null) {
          for (int i = 0; i < friends2.length; i++) {
            friendsids.add(friends2[i].userid1);
          }
          friendslist.addAll(friends2);
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

  Future updateBadge(Badge oldBadge, Badge newBadge) async {
    String id = _firebaseService.currentUser.uid;
    await userCollection.doc(id).update({
      "badges": FieldValue.arrayRemove([oldBadge.toMap()])
    });

    await userCollection.doc(id).update({
      "badges": FieldValue.arrayUnion([newBadge.toMap()])
    });
  }

  Future deleteGoal(Goal goal) async {
    if (goal.competitors == null) {
      await _goalsCollectionReference.doc(goal.docID).delete();
    } else {
      List<String> invIDs = [];
      await invationsCollection
          .where("creatorgoalDocId", isEqualTo: goal.docID)
          .get()
          .then((value) => value.docs.forEach((element) {
                invIDs.add(element.id);
              }));

      WriteBatch batch = FirebaseFirestore.instance.batch();
      try {
        DocumentReference goalDocRef =
            _goalsCollectionReference.doc(goal.docID);

        goal.competitors.forEach((element) {
          DocumentReference goalDocReference =
              _goalsCollectionReference.doc(element);
          batch.update(goalDocReference, {
            "competitors": FieldValue.arrayRemove([goal.docID])
          });
        });
        batch.delete(goalDocRef);
        invIDs.forEach((element) {
          DocumentReference invRef = invationsCollection.doc(element);
          batch.delete(invRef);
        });
        batch.commit();
      } catch (e) {
        print(e);
        return e.toString();
      }
    }
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
    goal.creatorId = _firebaseService.currentUser.uid;
    try {
      DocumentReference goalDocReference = _goalsCollectionReference.doc();
      goal.competitors.add(goalDocReference.id);
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
            competitors: goal.competitors,
            creatorId: goal.creatorId);

        DocumentReference newGoalDocRef = _goalsCollectionReference.doc();
        dynamic id = newGoalDocRef.id;

        goal.competitors.forEach((element) {
          DocumentReference goalRef = _goalsCollectionReference.doc(element);
          transaction.update(goalRef, {
            "competitors": FieldValue.arrayUnion([id])
          });
        });
        newGoal.competitors.add(newGoalDocRef.id);
        transaction.set(newGoalDocRef, newGoal.toMap());
      });
      return true;
    } catch (e) {
      print("the error was in ${e.toString()}");
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

  Stream<List<Invitation>> getReceivedInvations() {
    StreamController<List<Invitation>> invationsController =
        StreamController<List<Invitation>>.broadcast();
    if (_firebaseService.currentUser != null) {
      invationsCollection
          .where("receiverId", isEqualTo: _firebaseService.currentUser.uid)
          .where("status", isEqualTo: "Pending")
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
    StreamController<List<Invitation>> invationsController =
        StreamController<List<Invitation>>.broadcast();
    if (_firebaseService.currentUser != null) {
      invationsCollection
          .where("creatorId", isEqualTo: _firebaseService.currentUser.uid)
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

  Future addFriendship(Friends friends) async {
    var doc = await _friendsCollection.add(friends.toMap());
  }

  Future deleteFriend(String fid) async {
    for (int i = 0; i < friendslist.length; i++) {
      if (friendslist[i].userid1 == fid || friendslist[i].userid2 == fid) {
        await _friendsCollection.doc(friendslist[i].docID).delete();
      }
    }
  }

  Future<List<PeakUser>> getCompetitors() async {
    List<String> competitorsuids = [];
    List<PeakUser> peakUsers = [];
    if (_firebaseService.currentUser != null) {
      await _friendsCollection
          .where("userid1", isEqualTo: _firebaseService.currentUser.uid)
          .get()
          .then((value) async {
        value.docs.forEach((element) {
          var map = element.data();
          competitorsuids.add(map['userid2']);
        });
        await _friendsCollection
            .where("userid2", isEqualTo: _firebaseService.currentUser.uid)
            .get()
            .then((value) async {
          value.docs.forEach((element) {
            var map = element.data();
            competitorsuids.add(map['userid1']);
          });

          peakUsers = await getUsers(competitorsuids);
        });
      });
    }

    return peakUsers;
  }

  Future<List<Goal>> getCertainGoals(List<String> ids) async {
    List<Goal> users = [];
    try {
      await _goalsCollectionReference
          .where(FieldPath.documentId, whereIn: ids)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          users = value.docs
              .map((snapshot) => Goal.fromJson(snapshot.data(), snapshot.id))
              .toList();
        }
      });
      return users;
    } catch (e) {
      return null;
    }
  }
}

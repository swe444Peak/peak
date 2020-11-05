import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peak/models/goal.dart';
import 'package:peak/locator.dart';
import 'package:peak/models/invation.dart';
import 'package:peak/enums/InvationStatus.dart';
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

  final StreamController<List<PeakUser>> _userController =
      StreamController<List<PeakUser>>.broadcast();

  //collection reference
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  CollectionReference _goalsCollectionReference =
      FirebaseFirestore.instance.collection("goals");

  CollectionReference invationsCollection =
      FirebaseFirestore.instance.collection("invations");

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
    id = _firebaseService.currentUser.uid;
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

  Stream getUsers() {
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

  Future inviteFriends(List<Invation> invations, Goal goal) async {
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

  Future acceptGoalInvite(Invation invation) async {
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

        goal.competitors.forEach((element) {
          DocumentReference goalRef = _goalsCollectionReference.doc(element);
          dynamic id = newGoalDocRef.id;
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

  Future declinedGoalInvite(Invation invation) async {
    try {
      await invationsCollection
          .doc(invation.invationDocId)
          .update({"status": invation.status.toShortString()});
      return true;
    } catch (e) {
      return e.toString();
    }
  }
}

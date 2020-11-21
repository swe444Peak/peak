import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peak/services/authExceptionHandler.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/models/user.dart';
import 'package:peak/models/badges.dart';

import 'UsernameExistsException.dart';

class FirbaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  PeakUser currentUser;
  var defUserPic =
      "https://firebasestorage.googleapis.com/v0/b/peak-275b5.appspot.com/o/profile_default.png?alt=media&token=95761f67-00ef-41b8-a111-09dfdc6fe8c1";

  Future signUp(String username, String email, String password) async {
    
    try {
      await FirebaseFirestore.instance.collection("users").where('username',isEqualTo:username).get()
    .then((value) { if(value.docs.isNotEmpty)
         throw new UsernameExistsException();
    });

      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (result.user != null) {
        //creating an instance of database services to create new doc for the user with the uid
        //final DatabaseServices database = DatabaseServices(result.user);
        List<Badge> badges = new List<Badge>();
        List<Map<String,dynamic>> mapedBadges = new List<Map<String,dynamic>>();
        badges.add(Badge(name: "First goal", description: "Go ahead and add your first goal to win this badge!", goal: 1, counter: 0, status: false, dates: []));
        badges.add(Badge(name: "Achieve first task", description: "well, lets get on and achieve your first task to win this badge!", goal: 1, counter: 0, status: false, dates: []));
        badges.add(Badge(name: "50% Total Progress", description: "Raise your progress to 50% to get this badge!", goal: 1, counter: 0, status: false, dates: []));
        badges.add(Badge(name: "3 days of 100% productivity", description: "Ahieve all your daily tasks for 3 days to win this badge!", goal: 3, counter: 0, status: false, dates: []));
        currentUser =
            PeakUser(uid: result.user.uid, name: username, picURL: defUserPic, badges: badges);
        badges.forEach((b) {
          mapedBadges.add(b.toMap());
         });
        await DatabaseServices(uid: result.user.uid)
            .updateUserData(username: username, picURL: defUserPic, badges: mapedBadges);

        return true;
      }

      return AuthExceptionHandler.generateExceptionMessage(
          AuthResultStatus.undefined);
    } catch (e) {
      print('Exception @createAccount: $e');
      return AuthExceptionHandler.handleException(e);
    }
  }

  Future logIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      currentUser = PeakUser(uid: result.user.uid);
      
      if (result.user != null) {
        DatabaseServices().userData().listen((user) { 
        if(user != null)
        currentUser = user;
        });
        return true;
      }

      return AuthExceptionHandler.generateExceptionMessage(
          AuthResultStatus.undefined);
    } catch (e) {
      print('Exception: $e');
      return AuthExceptionHandler.handleException(e);
    }
  }

  Future forgetPassword(String email) async {
    try{
    await  _auth.sendPasswordResetEmail(email: email);
    }
    catch(e){
       print('Exception: $e');
      return AuthExceptionHandler.handleException(e);
    }

  }

  PeakUser getCurrentUser() {
    return currentUser;
  }

  Future logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return e.message;
    }
  }
}

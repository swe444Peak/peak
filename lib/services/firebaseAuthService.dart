import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peak/services/authExceptionHandler.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/models/user.dart';
import 'package:peak/services/userExistsException.dart';

import '../locator.dart';

class FirbaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  PeakUser currentUser;
  // final FirbaseAuthService _firbaseAuthService = locator<FirbaseAuthService>();

  // final CollectionReference userCollection =
  //     FirebaseFirestore.instance.collection("users");

  var defUserPic =
      "https://firebasestorage.googleapis.com/v0/b/peak-275b5.appspot.com/o/profile_default.png?alt=media&token=95761f67-00ef-41b8-a111-09dfdc6fe8c1";

  Future signUp(String username, String email, String password) async {
    try {


  await FirebaseFirestore.instance.collection("users").where('username',isEqualTo:username).get()
    .then((value) { if(value.docs.isNotEmpty)
         throw new UsernameExistsException();
         print("USERNAME EXCEPTION");
    });
   
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      
      if (result.user != null) {
        //creating an instance of database services to create new doc for the user with the uid
        //final DatabaseServices database = DatabaseServices(result.user);
        currentUser =
            PeakUser(uid: result.user.uid, name: username, picURL: defUserPic);
        await DatabaseServices(uid: result.user.uid)
            .updateUserData(username: username, picURL: defUserPic);

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
        return true;
      }

      return AuthExceptionHandler.generateExceptionMessage(
          AuthResultStatus.undefined);
    } catch (e) {
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

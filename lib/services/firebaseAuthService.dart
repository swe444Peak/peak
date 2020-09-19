import 'package:firebase_auth/firebase_auth.dart';
import 'package:peak/services/authExceptionHandler.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/models/user.dart';

class FirbaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  PeakUser currentUser;
  

  Future signUp(String username, String email, String password) async {

    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (result.user != null){ 
        //creating an instance of database services to create new doc for the user with the uid
        //final DatabaseServices database = DatabaseServices(result.user);
        await DatabaseServices(uid: result.user.uid).updateUserData(username: username);

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
      if (result.user != null) {
        currentUser = PeakUser(uid: result.user.uid);
        return true;
        }

      return AuthExceptionHandler.generateExceptionMessage(
          AuthResultStatus.undefined);
    } catch (e) {
      print('Exception: $e');
      return AuthExceptionHandler.handleException(e);
    }
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

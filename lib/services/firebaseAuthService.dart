import 'package:firebase_auth/firebase_auth.dart';
import 'package:peak/services/authExceptionHandler.dart';

class FirbaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signUp(String email, String password) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null) return true;

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
      if (result.user != null) return true;

      return AuthExceptionHandler.generateExceptionMessage(
          AuthResultStatus.undefined);
    } catch (e) {
      print('Exception @login: $e');
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

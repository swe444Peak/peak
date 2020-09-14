import 'package:firebase_auth/firebase_auth.dart';

class FirbaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signUp(String email, String password) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user != null;
    } catch (e) {
      print(e.message);
      return e.message;
    }
  }

  Future logIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print('uid: ${result.user.uid}');
      return result.user != null;
    } catch (e) {
      print(e.toString());
      return e.message;
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

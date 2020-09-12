import 'package:firebase_auth/firebase_auth.dart';

class FirbaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

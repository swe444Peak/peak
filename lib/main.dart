import 'package:flutter/material.dart';
import 'package:peak/screens/login.dart';
import 'package:peak/screens/signUp.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //TODO: wrapp with StremaProvider
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

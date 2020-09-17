import 'package:flutter/material.dart';
import 'package:peak/router.dart';
import 'package:firebase_core/firebase_core.dart';

import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      initialRoute: 'profile',
      onGenerateRoute: Router.generateRoute,
    );
  }
}

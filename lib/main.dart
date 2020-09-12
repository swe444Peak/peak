import 'package:flutter/material.dart';
import 'package:peak/screens/wrapper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //TODO: wrapp with StremaProvider
    return MaterialApp(
      home: Wrapper(),
    );
  }
}

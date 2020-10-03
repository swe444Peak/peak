import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatefulWidget {
  @override
  _CustomProgressIndicatorState createState() =>
      _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator> {
  void route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => x()));
  }

  initiateRoute() {
    var duration = Duration(seconds: 15);
    return Timer(duration, route);
  }

  @override
  void initState() {
    initiateRoute();
    super.initState();
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class x extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("data"),
    );
  }
}

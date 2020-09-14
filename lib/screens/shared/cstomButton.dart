import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton(this.onPressed, this.text);
  final GestureTapCallback onPressed;
  String text;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.teal,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: onPressed,
        child: Text(text,
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Color(0xff152a55), fontWeight: FontWeight.bold)),
      ),
    );
  }
}

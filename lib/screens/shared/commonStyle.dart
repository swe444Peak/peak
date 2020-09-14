import 'package:flutter/material.dart';

class CommonStyle {
  static InputDecoration textFieldStyle(String hintText) => InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      hintText: hintText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)));
}

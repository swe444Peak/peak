import 'package:flutter/material.dart';

InputDecoration textFieldStyle(String hintText) => InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    hintText: hintText,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)));

TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

Widget buildTextFiled(
    TextEditingController controller, bool isObscure, String hintText,
    [String Function(String) validator]) {
  return Theme(
    data: ThemeData(brightness: Brightness.dark),
    child: TextFormField(
      validator: validator,
      obscureText: isObscure,
      style: style,
      controller: controller,
      decoration: textFieldStyle(hintText),
    ),
  );
}

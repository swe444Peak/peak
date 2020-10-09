import 'package:flutter/material.dart';

InputDecoration textFieldStyle(String hintText, String errorText) =>
    InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: hintText,
        errorText: errorText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)));

TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

Widget buildTextFiled(TextEditingController controller, bool isObscure,
    String hintText, String errorText, void Function(String value) onChanged) {
  return Theme(
    data: ThemeData(brightness: Brightness.dark),
    child: TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: textFieldStyle(hintText, errorText),
      onChanged: (value) => onChanged(value),
    ),
  );
}

Widget specialTextField(TextEditingController controller, bool isObscure,
    String hintText, String errorText, void Function(String value) onChanged) {
  return TextField(
    controller: controller,
    obscureText: isObscure,
    decoration: textFieldStyle(hintText, errorText),
    style: TextStyle(
        color: Color.fromRGBO(23, 23, 85, 1.0),
        fontFamily: 'Montserrat',
        fontSize: 20.0),
    onChanged: (value) => onChanged(value),
  );
}

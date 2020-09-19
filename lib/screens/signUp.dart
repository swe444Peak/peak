import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/screens/shared/commonStyle.dart';
import 'package:peak/screens/shared/customButton.dart';
import 'package:peak/viewmodels/signup_model.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../locator.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formkey = GlobalKey<FormState>();
  String _error;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController _usernamecontroller = TextEditingController();
  TextEditingController _passwordcheckcontroller = TextEditingController();

  @override
  void dispose() {
    _emailcontroller.dispose();

    _passwordcontroller.dispose();

    super.dispose();
  }

  void showAlertDialog(BuildContext context, String error) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text(error),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final usernameField = buildTextFiled(_usernamecontroller, false, "name",
        RequiredValidator(errorText: 'please enter your name'));

    final emailField = buildTextFiled(
        _emailcontroller,
        false,
        "email",
        MultiValidator([
          RequiredValidator(errorText: 'email is required'),
          EmailValidator(errorText: 'enter a valid email address')
        ]));

    final passwordField = buildTextFiled(
      _passwordcontroller,
      true,
      "password",
      MultiValidator([
        RequiredValidator(errorText: 'password is required'),
        MinLengthValidator(6,
            errorText: 'password must be at least 6 characters long'),
      ]),
    );

    final passwordcheckField = buildTextFiled(
        _passwordcheckcontroller, true, "confirm password", (value) {
      return value.isEmpty
          ? "confirm password is required"
          : (value != _passwordcontroller.text
              ? "passwords don\'t match"
              : null);
    });

    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider<SignUpMaodel>(
      create: (context) => locator<SignUpMaodel>(),
      child: Consumer<SignUpMaodel>(
        builder: (context, model, child) => SafeArea(
          child: Scaffold(
            backgroundColor: Color.fromRGBO(23, 23, 85, 1.0),
            body: ModalProgressHUD(
              inAsyncCall: model.state == ViewState.Busy,
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          showAlert(),
                          SizedBox(height: size.height * 0.02),
                          Image.asset(
                            "assets/logo.png",
                            height: size.height * 0.28,
                          ),
                          SizedBox(height: size.height * 0.06),
                          usernameField,
                          SizedBox(height: size.height * 0.01),
                          emailField,
                          SizedBox(height: size.height * 0.01),
                          passwordField,
                          SizedBox(height: size.height * 0.01),
                          passwordcheckField,
                          SizedBox(height: size.height * 0.03),
                          CustomButton(() async {
                            if (_formkey.currentState.validate()) {
                              var success = await model.signUp(
                                  _usernamecontroller.text,
                                  _emailcontroller.text,
                                  _passwordcontroller.text);
                              if (success is bool && success) {
                                Navigator.pushNamed(context,
                                    'profile'); /*EDITED FOR SPRINT #1*/
                              } else {
                                _error = success;
                              }
                            }
                          }, "Sign Up"),
                          Text(
                            'Already have an account?',
                            style: TextStyle(
                                    fontSize: size.height / 35,
                                    fontWeight: FontWeight.bold)
                                .apply(color: Colors.white),
                          ),
                          _buildGestureDetector(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGestureDetector() {
    return GestureDetector(
        child: Center(
          child: Text("Sign in",
              style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline)
                  .apply(color: Colors.teal)),
        ),
        onTap: () {
          Navigator.pop(context);
        });
  }

  Widget showAlert() {
    if (_error != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: Text(_error),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _error = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }
}

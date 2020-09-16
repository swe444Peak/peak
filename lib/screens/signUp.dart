import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:peak/screens/shared/commonStyle.dart';
import 'package:peak/screens/shared/customButton.dart';
import 'package:peak/viewmodels/signup_model.dart';
import 'package:provider/provider.dart';

import '../locator.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key key, this.title}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  void initState() {
    super.initState();
  }

  final _formkey = GlobalKey<FormState>();

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

  bool fillFields() {
    if (_emailcontroller.text.isEmpty ||
        _passwordcontroller.text.isEmpty ||
        _usernamecontroller.text.isEmpty ||
        _passwordcheckcontroller.text.isEmpty) {
      showAlertDialog(context, 'Please fill all fields');
      return false;
    }
    return true;
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
    final usernameField =
        buildTextFiled(_usernamecontroller, false, "username");

    final emailField = buildTextFiled(_emailcontroller, false, "email");

    final passwordField = buildTextFiled(_passwordcontroller, true, "password");

    final passwordcheckField =
        buildTextFiled(_passwordcheckcontroller, true, "confirm password");

    return ChangeNotifierProvider<SignUpMaodel>(
      create: (context) => locator<SignUpMaodel>(),
      child: Consumer<SignUpMaodel>(
        builder: (context, model, child) => SafeArea(
          child: Scaffold(
            backgroundColor: Color(0xFF22488e),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formkey,
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Hero(
                      tag: "logo",
                      child: Container(
                        height: 190.0,
                        child: Image.asset('assets/logo.png'),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    usernameField,
                    SizedBox(
                      height: 10.0,
                    ),
                    emailField,
                    SizedBox(
                      height: 10.0,
                    ),
                    passwordField,
                    SizedBox(
                      height: 10.0,
                    ),
                    passwordcheckField,
                    SizedBox(
                      height: 30.0,
                    ),
                    CustomButton(() async {
                      if (_passwordcontroller.text !=
                          _passwordcheckcontroller.text) {
                        showAlertDialog(context, 'passwords don\'t match');
                      } else if (fillFields()) {
                        print(_passwordcontroller.text);
                        print(_passwordcheckcontroller.text);
                        var success = await model.signUp(
                            _emailcontroller.text, _passwordcontroller.text);
                        if (success is bool && success)
                          Navigator.pushNamed(context, '/');
                      }
                    }, "Sign Up"),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: Text('Already have an account?',
                          style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)
                              .apply(color: Colors.white)),
                    ),
                    _buildGestureDetector(),
                  ],
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
}

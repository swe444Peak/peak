import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:peak/screens/shared/commonStyle.dart';
import 'package:peak/screens/shared/customButton.dart';
import 'package:peak/viewmodels/login_model.dart';
import 'package:provider/provider.dart';

import '../locator.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  String _error;
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();

  @override
  void dispose() {
    _emailcontroller.dispose();

    _passwordcontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ChangeNotifierProvider<LoginMaodel>(
      create: (context) => locator<LoginMaodel>(),
      child: Consumer<LoginMaodel>(
        builder: (context, model, child) => SafeArea(
          child: Scaffold(
            backgroundColor: Color.fromRGBO(23, 23, 85, 1.0),
            body: SingleChildScrollView(
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
                        _buildEmailTextField(),
                        SizedBox(height: size.height * 0.01),
                        _buildPasswordTextField(),
                        SizedBox(height: size.height * 0.03),
                        CustomButton(() async {
                          if (_formkey.currentState.validate()) {
                            var success = await model.login(
                                _emailcontroller.text,
                                _passwordcontroller.text);
                            if (success is bool && success) {
                              Navigator.pushNamed(context, '/');
                            } else {
                              _error = success;
                            }
                          }
                        }, "Log in"),
                        Text(
                          'Not a member ?',
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
    );
  }

  Widget _buildEmailTextField() {
    return buildTextFiled(
        _emailcontroller,
        false,
        "email",
        MultiValidator([
          RequiredValidator(errorText: 'Please enter your email address'),
          EmailValidator(errorText: 'enter a valid email address')
        ]));
  }

  Widget _buildPasswordTextField() {
    return buildTextFiled(_passwordcontroller, true, "password",
        RequiredValidator(errorText: "Please enter your password"));
  }

  Widget _buildGestureDetector() {
    return GestureDetector(
      child: Center(
        child: Text(
          "SignUp",
          style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline)
              .apply(color: Colors.teal),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, 'signUp');
      },
    );
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

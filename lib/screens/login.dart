import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:peak/locator.dart';
import 'package:peak/screens/shared/customButton.dart';
import 'package:peak/screens/shared/commonStyle.dart';
import 'package:peak/screens/signUp.dart';
import 'package:peak/viewmodels/login_model.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();

  final _formKey = new GlobalKey<FormState>();
  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginMaodel>(
      create: (context) => locator<LoginMaodel>(),
      child: Consumer<LoginMaodel>(
        builder: (context, model, child) => SafeArea(
          child: Scaffold(
            backgroundColor: Color(0xFF22488e),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
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
                    _buildEmailTextFiled(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _buildPasswordTextFiled(),
                    SizedBox(
                      height: 30.0,
                    ),
                    CustomButton(() async {
                      if (_formKey.currentState.validate()) {
                        var success = await model.login(
                            _emailcontroller.text, _passwordcontroller.text);
                        if (success is bool && success)
                          Navigator.pushNamed(context, '/');
                      }
                    }, "Log in"),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: Text(
                        'Not a member ?',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                                .apply(color: Colors.white),
                      ),
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

  Widget _buildEmailTextFiled() {
    return buildTextFiled(_emailcontroller, false, "emil",
        (value) => value.isEmpty ? "email field cannot be empty" : null);
  }

  Widget _buildPasswordTextFiled() {
    return buildTextFiled(_passwordcontroller, true, "password",
        (value) => value.isEmpty ? "Password filed cannot be empty" : null);
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
}

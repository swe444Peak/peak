import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:peak/screens/shared/cstomButton.dart';
import 'package:peak/screens/shared/commonStyle.dart';
import 'package:peak/screens/signUp.dart';
import 'package:peak/services/firebaseAuthService.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
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
    final emailField = Theme(
      data: new ThemeData(brightness: Brightness.dark),
      child: new TextFormField(
        controller: _emailcontroller,
        obscureText: false,
        style: style,
        decoration: CommonStyle.textFieldStyle("email"),
      ),
    );

    final passwordField = Theme(
      data: new ThemeData(brightness: Brightness.dark),
      child: new TextFormField(
        controller: _passwordcontroller,
        obscureText: true,
        style: style,
        decoration: CommonStyle.textFieldStyle("password"),
      ),
    );

    final loginButton = CustomButton(() {
      FirbaseAuthService()
          .logIn(_emailcontroller.text, _passwordcontroller.text);
    }, "Log in");

    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/BackGround-Login.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 300.0),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                loginButton,
                SizedBox(
                  height: 50.0,
                ),
                Text('Not a member ?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        .apply(color: Colors.white)),
                GestureDetector(
                    child: Text("SignUp",
                        style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline)
                            .apply(color: Colors.teal)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupPage()));
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

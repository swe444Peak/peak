import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:peak/services/firebaseAuthService.dart';

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
  String password = '';
  String username = '';
  String email = '';

  TextEditingController _emailcontroller = TextEditingController();

  TextEditingController _passwordcontroller = TextEditingController();

  TextEditingController _usernamecontroller = TextEditingController();

  @override
  void dispose() {
    _emailcontroller.dispose();

    _passwordcontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usernameField = Theme(
      data: new ThemeData(brightness: Brightness.dark),
      child: new TextFormField(
          controller: _usernamecontroller,
          obscureText: false,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Username",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please Fill Email Input';
            }
          }
          //onChanged: (value) => username = value,
          ),
    );

    final emailField = Theme(
      data: new ThemeData(brightness: Brightness.dark),
      child: new TextFormField(
        controller: _emailcontroller,
        obscureText: false,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Email",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please Fill Email Input';
          }
        },
        //onChanged: (value) => email = value,
      ),
    );

    final passwordField = Theme(
      data: new ThemeData(brightness: Brightness.dark),
      child: new TextFormField(
        controller: _passwordcontroller,
        obscureText: true,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please Fill Email Input';
          }
        },
        onChanged: (value) {
          print(value);
          password = value;
          print(password);
        },
      ),
    );

    final signUpButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff152a55),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          FirbaseAuthService()
              .signUp(_emailcontroller.text, _passwordcontroller.text);
        },
        child: Text("Sign Up",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final backtologinButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff152a55),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("Back to sign in",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/BackGround-signup.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 100.0),
                usernameField,
                SizedBox(height: 25.0),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                signUpButton,
                SizedBox(
                  height: 15.0,
                ),
                backtologinButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

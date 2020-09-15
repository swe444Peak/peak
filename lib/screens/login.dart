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
    return ChangeNotifierProvider<LoginMaodel>(
      create: (context) => locator<LoginMaodel>(),
      child: Consumer<LoginMaodel>(
        builder: (context, model, child) => SafeArea(
          child: Scaffold(
            backgroundColor: Color(0xFF22488e),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  Hero(
                    tag: "logo",
                    child: Container(
                      height: 190.0,
                      child: Image.asset('assets/logo.png'),
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Theme(
                    data: ThemeData(brightness: Brightness.dark),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailcontroller,
                      decoration: CommonStyle.textFieldStyle("email"),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Theme(
                    data: ThemeData(brightness: Brightness.dark),
                    child: TextFormField(
                      obscureText: true,
                      controller: _passwordcontroller,
                      decoration: CommonStyle.textFieldStyle("password"),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  CustomButton(() async {
                    var success = await model.login(
                        _emailcontroller.text, _passwordcontroller.text);
                    print(success);
                    if (success is bool && success) {
                      Navigator.pushNamed(context, '/');
                    }
                  }, "Log in"),
                  SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: Center(
                      child: Text(
                        'Not a member ?',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                                .apply(color: Colors.white),
                      ),
                    ),
                  ),
                  GestureDetector(
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupPage()));
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

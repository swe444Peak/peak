import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:peak/enums/viewState.dart';
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

    return ChangeNotifierProvider<LoginModel>(
      create: (context) => locator<LoginModel>(),
      child: Consumer<LoginModel>(
        builder: (context, model, child) => SafeArea(
          child: Scaffold(
            backgroundColor: Color.fromRGBO(23, 23, 85, 1.0),
            body: ModalProgressHUD(
              inAsyncCall: model.state == ViewState.Busy,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                      buildTextFiled(_emailcontroller, false, "email",
                          model.email.error, model.setEmail),
                      SizedBox(height: size.height * 0.01),
                      buildTextFiled(_passwordcontroller, true, "password",
                          model.password.error, model.setPassword),
                      SizedBox(height: size.height * 0.03),
                      FlatButton(
	                            child: Text("Forgot Password?", 
	                            style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0,color: Colors.white, decoration: TextDecoration.underline)),
	                            onPressed: (){
	                              Navigator.pushNamed(context, 'forgotPassword');
	                            },
	                          )
                      ,
                      CustomButton(() async {
                        if (model.isValid) {
                          var success = await model.login(
                              _emailcontroller.text, _passwordcontroller.text);
                          if (success is bool && success) {
                            Navigator.pushNamed(context, 'profile');  //****** */
                          } else {
                            _error = success;
                          }
                        } else {
                          if (model.email.error == null &&
                              model.email.value == null) {
                            model.setEmail("");
                          }
                          if (model.password.error == null &&
                              model.password.value == null) {
                            model.setPassword("");
                          }
                        }
                      }, "Sign in"),
                      SizedBox(height: size.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                    ],
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
      child: Text(
        "Sign Up",
        style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline)
            .apply(color: Colors.teal),
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

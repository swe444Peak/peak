import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import '../enums/viewState.dart';
import '../locator.dart';
import '../viewmodels/login_model.dart';
import 'shared/customButton.dart';
import 'shared/commonStyle.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ForgotPassword();
  }
}

class _ForgotPassword extends State<ForgotPasswordPage> {
  TextEditingController _emailcontroller = TextEditingController();
  var _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final submit = CustomButton(() async {
      if (_formkey.currentState.validate()) {
        FirebaseAuth.instance
            .sendPasswordResetEmail(email: _emailcontroller.text)
            .then((value) => print("Check your mails"));
      }
    }, "Send email");

    Widget _buildGestureDetector() {
      return GestureDetector(
          child: Center(
            child: Text("Retun to Sign in",
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
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: size.height * 0.14),
                        Text("We will send you an Email to reset your password",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 22.0,
                                color: Colors.teal[50])),
                        SizedBox(height: size.height * 0.06),
                         buildTextFiled(_emailcontroller, false, "email",
                          model.email.error, model.setEmail),
                        SizedBox(height: size.height * 0.05),
                        submit,
                        SizedBox(height: size.height * 0.08),
                        _buildGestureDetector()
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
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
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
   var _formkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    final emailField = buildTextFiled(
        _emailcontroller,
        false,
        "email",
        MultiValidator([
          RequiredValidator(errorText: 'email is required'),
          EmailValidator(errorText: 'enter a valid email address')
        ]));

    final submit = CustomButton(() async {
                            if (_formkey.currentState.validate()) {
                                FirebaseAuth.instance.sendPasswordResetEmail(email:_emailcontroller.text)
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

    return Scaffold(
      backgroundColor: Color.fromRGBO(23, 23, 85, 1.0),
      body: Center(
        child: Padding(padding: EdgeInsets.only(top: 50),
        
        child: Form(
          key: _formkey,
          child: Column(children: <Widget>[
             SizedBox(height: size.height * 0.14),
             Text("We will send you an Email to reset your password",textAlign: TextAlign.center,
             style: TextStyle(fontFamily: 'Montserrat', fontSize: 22.0, color: Colors.teal[50])),
              SizedBox(height: size.height * 0.06),
            emailField, 
              SizedBox(height: size.height * 0.05)
            ,
            submit,
            SizedBox(height: size.height * 0.08),
            _buildGestureDetector()
       
          ],
          ),
        ),
        ),
      ),
    );
  }
}

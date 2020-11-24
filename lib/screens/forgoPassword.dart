import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:peak/services/authExceptionHandler.dart';
import 'package:peak/services/dialogService.dart';
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
  String _error;
  var _formkey = GlobalKey<FormState>();
  DialogService dialogService = locator<DialogService>();
  @override
  Widget build(BuildContext context) {
  

    Widget _buildBackButton() {
      return OutlineButton(
        highlightElevation: 5.0,
        color: Color.fromRGBO(23, 23, 85, 1.0),
         child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: (){
          Navigator.pop(context);
        },
        child: Text('Back to Sign in',
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.teal, fontWeight: FontWeight.bold)),
      ),
        onPressed:(){
          Navigator.pop(context);
        },
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
          borderSide: BorderSide(color: Colors.teal,width: 2.0),
               
);
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
                      children: [
                        showAlert(),
                        SizedBox(height: size.height * 0.27),
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
                        CustomButton(() async {
                          if (_formkey.currentState.validate()) {
                            var suc = await model
                                .forgetPassword(_emailcontroller.text);
                            _error = suc;
                            if (_error == null) {
                              // Navigator.pop(context);
                              dialogService.showDialog(
                                  title: "Email sent",
                                  description:
                                      "Reset password link has been sent, please check out your email.");
                            }
                          }
                          // Navigator.pop(context);
                        }, "Send email"),
                        SizedBox(height: size.height * 0.05),
                        _buildBackButton(),
                        ClipPath(
                          clipper: WaveClipperOne(),
                          child: Container(
                            //margin: EdgeInsets.fromLTRB(0, 0.0, width * 0.2, 0.0),
                            decoration: BoxDecoration(
                                color: Colors.indigo[500],
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.teal[400],
                                      Colors.indigo[600],
                                      Colors.deepPurple[900]
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomCenter)),
                          ),
                        )
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

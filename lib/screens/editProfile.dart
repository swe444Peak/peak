import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:peak/enums/viewState.dart';

import 'package:peak/models/user.dart';
import 'package:peak/screens/shared/customButton.dart';
import 'package:peak/services/UsernameExistsException.dart';
import 'package:peak/services/authExceptionHandler.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/services/firebaseAuthService.dart';
import 'package:peak/viewmodels/editProfile_model.dart';
import 'package:provider/provider.dart';

import '../locator.dart';

class EditProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _editnamecontroller = new TextEditingController();
  final _database = locator<DatabaseServices>();
  final _fireService = locator<FirbaseAuthService>();
  File pickedImage;
  String _error;

  EditProfileModel model = locator<EditProfileModel>();
  @override
  void initState() {
    // EditProfileModel().setName("");
    model.setName(_fireService.currentUser.name);
    super.initState();
  }

  @override
  void dispose() {
    _editnamecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    final double circleRadius = 250.0;
    final double circleBorderWidth = 10;
    var pic = _fireService.currentUser.picURL;

    return StreamProvider<PeakUser>.value(
        initialData: PeakUser(uid: "", name: ""),
        value: DatabaseServices().userData(user.uid),
        builder: (context, snapshot) {
          return ChangeNotifierProvider<EditProfileModel>(
              create: (context) => model,
              child: Consumer<EditProfileModel>(
                  builder: (context, model, child) => SafeArea(
                          child: Scaffold(
                        extendBodyBehindAppBar: true,
                        backgroundColor: Color.fromRGBO(23, 23, 85, 1.0),
                        appBar: AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0.0,
                          bottom: PreferredSize(
                            preferredSize:
                                Size(MediaQuery.of(context).size.width, 50),
                            child: showAlert(),
                          ),
                        ),
                        body: ModalProgressHUD(
                          inAsyncCall: model.state == ViewState.Busy,
                          child: SingleChildScrollView(
                            child: Stack(
                              children: [
                                Container(
                                  width: width * 0.8,
                                  height: width * 0.6,
                                  margin: EdgeInsets.fromLTRB(
                                      0, 0.0, width * 0.2, 0.0),
                                  decoration: BoxDecoration(
                                      color: Colors.indigo[500],
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(400)),
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.teal[400],
                                            Colors.indigo[600],
                                            Colors.deepPurple[900]
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomCenter)),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(width * 0.06,
                                      height * 0.12, width * 0.06, 0.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 0.0, 0.0, (width * 0.06)),
                                        child: Text(
                                          "Edit Profile",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 34.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: (height * 0.20)),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Container(
                                          width: circleRadius,
                                          height: circleRadius,
                                          decoration: ShapeDecoration(
                                            shape: CircleBorder(),
                                            gradient: LinearGradient(
                                                colors: [
                                                  Colors.teal[400],
                                                  Colors.indigo[600],
                                                  Colors.deepPurple[900]
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                circleBorderWidth),
                                            child: GestureDetector(
                                              onTap: () async {
                                                // await EditProfileModel()
                                                //     .uploadPic();
                                                File picked =
                                                    await EditProfileModel()
                                                        .pickImage();
                                                if (picked != null) {
                                                  setState(() {
                                                    pickedImage = picked;
                                                  });
                                                  // updateConfirmDailog(
                                                  //     context, "picture");
                                                }
                                              },
                                              child: Container(
                                                //height: 200,
                                                //width: 200,
                                                child: DecoratedBox(
                                                  decoration: ShapeDecoration(
                                                    shape: CircleBorder(),
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                              Colors.white
                                                                  .withOpacity(
                                                                      0.25),
                                                              BlendMode
                                                                  .dstATop),
                                                      image: pickedImage == null
                                                          ? NetworkImage(pic)
                                                          : FileImage(
                                                              pickedImage),
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    Icons.add_photo_alternate,
                                                    color: Colors.white,
                                                    size: 32,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 30),
                                        Container(
                                          width: width * 0.9,
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Card(
                                              elevation: 20,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    width * 0.06),
                                                child: TextField(
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                    controller:
                                                        _editnamecontroller,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          "${Provider.of<PeakUser>(context).name}",
                                                      labelStyle: TextStyle(
                                                          fontSize: 20),
                                                      errorText:
                                                          model.name.error,
                                                    ),
                                                    onChanged: (value) {
                                                      model.setName(value);
                                                    }),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: width * 0.5,
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0.0,
                                                    width * 0.03,
                                                    0.0,
                                                    0.0),
                                                child: CustomButton(() async {
                                                  try {
                                                    var exist =
                                                        await model.isexist(
                                                            model.name.value);

                                                    if (exist) {
                                                      print("in exception");

                                                      setState(() {
                                                        _error =
                                                            "username already exists";
                                                      });
                                                      throw new UsernameExistsException();
                                                    }

                                                    if (model.isValid) {
                                                      if (pickedImage == null) {
                                                        await model.updateName(
                                                            model.name.value);
                                                      } else {
                                                        await model.update(
                                                            pickedImage,
                                                            model.name.value);
                                                      }
                                                      // setState(() {
                                                      //   EditProfileModel()
                                                      //       .setName("");
                                                      // });
                                                      //   updateConfirmDailog(
                                                      //       context, "name");
                                                      Navigator.pushNamed(
                                                          context, 'profile');
                                                      updateConfirmDailog(
                                                          context,
                                                          "your profile was Updated successfully");
                                                    }
                                                    return AuthExceptionHandler
                                                        .generateExceptionMessage(
                                                            AuthResultStatus
                                                                .undefined);
                                                  } catch (e) {
                                                    return AuthExceptionHandler
                                                        .handleException(e);
                                                  }
                                                }, "Save"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ))));
        });
  }

  updateConfirmDailog(BuildContext context, String content) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          contentPadding: EdgeInsets.all(5),
          title: Text("Changed Successfully !"),
          content: Column(
            children: [
              SizedBox(height: 10),
              Text(content),
            ],
          ),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
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

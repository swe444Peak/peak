import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peak/models/user.dart';
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
  @override
  void initState() {
    EditProfileModel().setName("");
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
    return StreamProvider<PeakUser>.value(
        initialData: PeakUser(uid: "", name: ""),
        value: DatabaseServices().userData(user.uid),
        builder: (context, snapshot) {
          return ChangeNotifierProvider<EditProfileModel>(
              create: (context) => locator<EditProfileModel>(),
              child: Consumer<EditProfileModel>(
                  builder: (context, model, child) => SafeArea(
                          child: Scaffold(
                        extendBodyBehindAppBar: true,
                        backgroundColor: Color.fromRGBO(23, 23, 85, 1.0),
                        appBar: AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0.0,
                        ),
                        body: SingleChildScrollView(
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
                                            child: Container(
                                              //height: 200,
                                              //width: 200,
                                              child: DecoratedBox(
                                                decoration: ShapeDecoration(
                                                    shape: CircleBorder(),
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                            "${Provider.of<PeakUser>(context).picURL}"))),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 30),
                                        Container(
                                          width: 355,
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
                                              width: 175,
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0.0, 0.0, 0.0, 8.0),
                                                child: Card(
                                                  elevation: 20,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: ListTile(
                                                      leading: Icon(
                                                        Icons
                                                            .add_photo_alternate,
                                                        color: Color.fromRGBO(
                                                            23, 23, 85, 1.0),
                                                        size: 32,
                                                      ),
                                                      title: Text(
                                                        "Change Picture",
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              23, 23, 85, 1.0),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      onTap: () async {
                                                        await EditProfileModel()
                                                            .uploadPic();
                                                        updateConfirmDailog(
                                                            context, "picture");
                                                      }),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 175,
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0.0, 0.0, 0.0, 8.0),
                                                child: Card(
                                                  elevation: 20,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: ListTile(
                                                      leading: Icon(
                                                        Icons.assignment_ind,
                                                        color: Color.fromRGBO(
                                                            23, 23, 85, 1.0),
                                                        size: 32,
                                                      ),
                                                      title: Text(
                                                        "Update Name",
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              23, 23, 85, 1.0),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      onTap: () async {
                                                        if (model.isValid) {
                                                          print(model.isValid);
                                                          print(model.name);
                                                          var upload = await model
                                                              .updateName(
                                                                  _editnamecontroller
                                                                      .text
                                                                      .trim());
                                                          updateConfirmDailog(
                                                              context, "name");
                                                          setState(() {
                                                            EditProfileModel()
                                                                .setName("");
                                                          });
                                                        }
                                                      }),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
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
              Text("your $content was Updated successfully"),
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
}

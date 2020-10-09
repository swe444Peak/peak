import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peak/models/user.dart';
import 'package:peak/screens/goalsList.dart';
import 'package:peak/screens/profile.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:provider/provider.dart';

class GoalConfirmationPage extends StatefulWidget {
  @override
  _GoalConfirmationPageState createState() => _GoalConfirmationPageState();
}

class _GoalConfirmationPageState extends State<GoalConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var user = Provider.of<User>(context);
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return StreamProvider<PeakUser>.value(
        initialData: PeakUser(uid: "", name: ""),
        value: DatabaseServices().userData(user.uid),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Color.fromRGBO(23, 23, 85, 1.0),
            body: SingleChildScrollView(
              child: Stack(children: [
                Container(
                  width: width * 0.8,
                  height: width * 0.6,
                  margin: EdgeInsets.fromLTRB(width * 0.2, 0.0, 0.0, 0.0),
                  decoration: BoxDecoration(
                      color: Colors.indigo[500],
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(400)),
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
                  padding: EdgeInsets.fromLTRB(
                      width * 0.06, height * 0.12, width * 0.06, 0.0),
                  child: Column(children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              0.0, 0.0, 0.0, (width * 0.06)),
                          child: Text(
                            "Confirmation",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: Column(children: [
                              SizedBox(height: size.height * 0.04),
                              Align(
                                alignment: Alignment.center,
                                child: Text("Goal\'s name",
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 30.0,
                                        color: Color.fromRGBO(23, 23, 85, 1.0)),
                                    textAlign: TextAlign.center),
                              ),
                              SizedBox(height: size.height * 0.02),
                              Align(
                                alignment: Alignment.center,
                                child: Text("De/ad/line",
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 22.0,
                                        color: Color.fromRGBO(23, 23, 85, 1.0)),
                                    textAlign: TextAlign.center),
                              ),
                              SizedBox(height: size.height * 0.02),
                              Container(
                                //TASK CONTAINER !!!!!
                                decoration: BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  child: Column(children: [
                                    SizedBox(height: size.height * 0.04),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text("Task name",
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 27.0,
                                                    color: Colors.white),
                                                textAlign: TextAlign.center),
                                          ),
                                          SizedBox(height: size.height * 0.02),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Text("Type",
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 22.0,
                                                    color: Colors.white),
                                                textAlign: TextAlign.center),
                                          ),
                                        ]),
                                    SizedBox(height: size.height * 0.02),
                                  ]),
                                ),
                              ),
                              SizedBox(height: size.height * 0.04),
                              Row(
                                //Buttons !!!!!!!!
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ButtonTheme(
                                    minWidth: 100.0,
                                    height: 50.0,
                                    child: RaisedButton(
                                      splashColor: Colors.teal,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                      color: Color.fromRGBO(23, 23, 85, 1.0),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    new ProfilePage()));
                                      },
                                      textColor: Colors.white,
                                      child: Text('Cancel',
                                          style: TextStyle(fontSize: 19.0)),
                                    ),
                                  ),
                                  ButtonTheme(
                                    minWidth: 100.0,
                                    height: 50.0,
                                    child: RaisedButton(
                                      splashColor: Colors.teal,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                      color: Color.fromRGBO(23, 23, 85, 1.0),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    new GoalsListPage()));
                                      }, // sucess message
                                      textColor: Colors.white,
                                      child: Text('Confirm',
                                          style: TextStyle(fontSize: 19.0)),
                                    ),
                                  ),
                                ],
                              ),
                            ]))),
                    SizedBox(height: size.height * 0.04),
                  ]),
                ),
              ]),
            ),
          );
        });
  }
}

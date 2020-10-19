import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peak/services/firebaseAuthService.dart';

import 'package:provider/provider.dart';
import 'package:peak/screens/shared/custom_bottomNavigationBar.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/models/user.dart';

import '../locator.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    final _firebaseService = locator<FirbaseAuthService>();
    //User user;

    return StreamProvider<PeakUser>.value(
        initialData: PeakUser(uid: "", name: ""),
        value: DatabaseServices().userData(user?.uid),
        builder: (context, snapshot) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Color.fromRGBO(23, 23, 85, 1.0),

            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              leading: Padding(padding: EdgeInsets.only(top: 0.0)),
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, 'settings');
                    })
              ],
            ),

            //common
            bottomNavigationBar: CustomNavigationBar(2),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, 'addNewGoal');
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.teal[400],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            //end common

            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    width: width,
                    height: height * 0.32,
                    //margin: EdgeInsets.fromLTRB(0, 0.0, 0.0, 0.0),
                    decoration: BoxDecoration(
                        //color: Colors.indigo[500],
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(
                                200)) /*.only(bottomLeft: Radius.circular(150))*/,
                        gradient: LinearGradient(
                            colors: [
                              Colors.teal[400],
                              Colors.indigo[600],
                              Colors.deepPurple[900]
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: (height * 0.03)),
                    child: Center(
                      child: Column(
                        children: [
                          // PROFILE PIC HERE
                          Container(
                            width: width * 0.4,
                            height: width * 0.4,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    "${Provider.of<PeakUser>(context).picURL}"),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.black26,
                                  offset: new Offset(0.0, -8.0),
                                  blurRadius: 40.0,
                                  spreadRadius: 1.0,
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${Provider.of<PeakUser>(context).name}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

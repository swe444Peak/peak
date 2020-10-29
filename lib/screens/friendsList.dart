import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peak/models/user.dart';
import 'package:peak/screens/shared/custom_bottomNavigationBar.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:provider/provider.dart';

class FriendsList extends StatefulWidget {
  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  @override
  Widget build(BuildContext context) {
    var userId = Provider.of<User>(context);
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    return StreamProvider<PeakUser>.value(
        initialData: PeakUser(uid: "", name: ""),
        value: DatabaseServices().userData(userId?.uid),
        builder: (context, snapshot) {
          return Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Color.fromRGBO(23, 23, 85, 1.0),
              bottomNavigationBar: CustomNavigationBar(3),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'addNewGoal');
                },
                child: Icon(Icons.add),
                backgroundColor: Colors.teal[400],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endDocked,
              body: SingleChildScrollView(
                  child: Stack(children: [
                Container(
                  width: width * 0.8,
                  height: width * 0.6,
                  margin: EdgeInsets.fromLTRB(0, 0.0, width * 0.2, 0.0),
                  decoration: BoxDecoration(
                      color: Colors.indigo[500],
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(400)),
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
                          padding:
                              EdgeInsets.fromLTRB(0.0, 0.0, 0.0, (width * 0.1)),
                          child: Text(
                            "Friends List",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Card(
                      //card Property
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),

                      child: ListTile(
                        contentPadding: EdgeInsets.fromLTRB(width * 0.05,
                            height * 0.01, width * 0.05, height * 0.01),
                        title: Row(
                          children: [
                            Container(
                              width: width * 0.15,
                              height: width * 0.15,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "https://static0.cbrimages.com/wordpress/wp-content/uploads/2019/09/One-Piece-Monkey-D.-Luffy-Cropped.jpg"),
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
                            SizedBox(width: width * 0.03),
                            Text(
                              "MonkeyDDDDDDDDDD",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.delete,
                              color: Colors.red[900],
                              size: 30,
                            ),
                          ],
                        ),
                        onTap: () {
                          //Navigator.pushNamed(context, "goalDetails", arguments: goal);
                        },
                      ),
                    ),
                  ]),
                ),
              ])));
        });
  }
}

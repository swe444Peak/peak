import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/models/user.dart';
import 'package:peak/screens/shared/custom_bottomNavigationBar.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/viewmodels/friendsList_model.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import '../locator.dart';

class FriendsList extends StatefulWidget {
  @override
  _FriendsListState createState() => _FriendsListState();
}

initState() {}

class _FriendsListState extends State<FriendsList> {
  @override
  Widget build(BuildContext context) {
    var userId = Provider.of<User>(context);
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    return ViewModelBuilder<FriendsListModel>.reactive(
        viewModelBuilder: () => locator<FriendsListModel>(),
        onModelReady: (model) => model.readfriendslist(),
        builder: (context, model, child) => Scaffold(
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
            body: Stack(children: [
              Container(
                width: width * 0.8,
                height: width * 0.6,
                margin: EdgeInsets.fromLTRB(0, 0.0, width * 0.2, 0.0),
                decoration: BoxDecoration(
                    color: Colors.indigo[500],
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(400)),
                    gradient: LinearGradient(colors: [
                      Colors.teal[400],
                      Colors.indigo[600],
                      Colors.deepPurple[900]
                    ], begin: Alignment.topLeft, end: Alignment.bottomCenter)),
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
                      IconButton(
                          icon: Icon(
                            Icons.add,
                            size: 30,
                          ),
                          color: Colors.white,
                          onPressed: () {
                            //ll
                          }),
                    ],
                  ),
                  Flexible(child: friendsList(model, width, height)),
                ]),
              ),
            ])));
  }

  Widget friendsList(model, width, height) {
    if (model.state == ViewState.Busy) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (model.empty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            "You don't have any friends!",
            style: TextStyle(fontSize: width * 0.06, color: Colors.white),
          ),
        ),
      );
    }
    if (model.friends != null) {
      return ListView.builder(
          itemCount: model.friends.length,
          itemBuilder: (context, index) {
            var friend = model.friends[index];
            return Card(
                //card Property
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(width * 0.008),
                  child: ListTile(
                    contentPadding: EdgeInsets.fromLTRB(
                        width * 0.05, height * 0.02, 0.0, height * 0.01),
                    title: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(
                              0.0, height * 0.008, 0.0, height * 0.008),
                          //width: width * 0.15,
                          //height: width * 0.15,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(friend.picURL),
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
                        //SizedBox(width: width * 0.03),
                        Text(
                          friend.name,
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                        //Spacer(),
                        IconButton(
                            padding: EdgeInsets.fromLTRB(
                                0.0, height * 0.01, 0.0, height * 0.01),
                            icon: Icon(
                              Icons.delete,
                              size: 30,
                            ),
                            color: Colors.red[900],
                            onPressed: () {}),
                      ],
                    ),
                    onTap: () {
                      //Navigator.pushNamed(context, "goalDetails", arguments: goal);
                    },
                  ),
                ));
          });
    }
    return Text("issue");
  }
}

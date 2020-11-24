import 'package:flutter/material.dart';
import 'package:peak/enums/viewState.dart';

import 'package:peak/models/user.dart';
import 'package:peak/screens/shared/baseWithAppBar.dart';
import 'package:peak/viewmodels/addCompetitors_model.dart';
import 'package:stacked/stacked.dart';
import '../locator.dart';

class AddCompetitors extends StatefulWidget {
  List<PeakUser> addedFriends;
  AddCompetitors({this.addedFriends, Key key}) : super(key: key);
  @override
  AddCompetitorsState createState() => AddCompetitorsState();
}

class AddCompetitorsState extends State<AddCompetitors> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return ViewModelBuilder<AddCompetitorsModel>.reactive(
        viewModelBuilder: () => locator<AddCompetitorsModel>(),
        onModelReady: (model) => model.readCompetitors(),
        builder: (context, model, child) => BaseWithAppBar(
              title: "Add Competitors",
              leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      widget.addedFriends = [];
                    });
                    Navigator.pop(context, 0);
                  }),
              childPadding: EdgeInsets.all(0),
              child: Column(
                children: [
                  Container(
                    height: height * 0.83,
                    margin: EdgeInsetsDirectional.only(top: height * 0.04),
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: model.state == ViewState.Busy
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : model.empty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "You don't have any friends!",
                                        style: TextStyle(
                                            fontSize: width * 0.06,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        "Go to the friends list and add some friends.",
                                        style: TextStyle(
                                            fontSize: width * 0.04,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: model.users.length,
                                itemBuilder: (context, index) {
                                  PeakUser currentUser = model.users[index];
                                  return Card(
                                    elevation: 20,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        tileColor: Colors.white,
                                        leading: Container(
                                          padding: EdgeInsets.fromLTRB(
                                              0.0,
                                              height * 0.008,
                                              0.0,
                                              height * 0.008),
                                          width: width * 0.15,
                                          height: width * 0.15,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  currentUser.picURL),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            boxShadow: [
                                              new BoxShadow(
                                                color: Colors.black26,
                                                offset:
                                                    new Offset(0.0, -0.0001),
                                                blurRadius: 10.0,
                                                spreadRadius: 0.0002,
                                              )
                                            ],
                                          ),
                                        ), //end leading
                                        title: Text(currentUser.name),
                                        trailing: IconButton(
                                          icon: checkAdded(currentUser.name)
                                              ? Icon(
                                                  Icons.cancel,
                                                  color: Colors.red,
                                                )
                                              : Icon(
                                                  Icons.add_circle_outline,
                                                  color: Colors.grey,
                                                ),
                                          onPressed: () {
                                            PeakUser user = PeakUser(
                                                uid: currentUser.uid,
                                                name: currentUser.name,
                                                picURL: currentUser.picURL,
                                                badges: currentUser.badges);
                                            if (checkAdded(currentUser.name))
                                              _removeFromFriends(user);
                                            else
                                              _addToFriends(user);
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                } //itemBuilder
                                ),
                  ),
                  (widget.addedFriends.isNotEmpty)
                      ? Container(
                          //alignment: Alignment.bottomCenter,
                          //margin: EdgeInsets.only(top: height*0.05),
                          child: Card(
                            elevation: 20,
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsetsDirectional.only(
                                          start: width * 0.008),
                                      width: width * 0.7,
                                      height: height * 0.1,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: widget.addedFriends.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            margin: EdgeInsets.symmetric(vertical: height * 0.008,horizontal: height * 0.008),
                                            // padding: EdgeInsets.fromLTRB(
                                            //     0.0,
                                            //     height * 0.008,
                                            //     0.0,
                                            //     height * 0.008),
                                            width: width * 0.15,
                                            height: width * 0.15,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(widget
                                                    .addedFriends[index]
                                                    .picURL),
                                                fit: BoxFit.fill,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(200),
                                              // boxShadow: [
                                              //   new BoxShadow(
                                              //     color: Colors.black26,
                                              //     offset:
                                              //         new Offset(0.0, -0.1),
                                              //     blurRadius: 8.0,
                                              //     spreadRadius: 0.1,
                                              //   )
                                              // ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    // Wrap(
                                    //   children: List<Widget>.generate(
                                    //       widget.addedFriends.length, (index) {
                                    //     return Container(
                                    //       padding: EdgeInsets.fromLTRB(
                                    //           0.0,
                                    //           height * 0.008,
                                    //           0.0,
                                    //           height * 0.008),
                                    //       width: width * 0.15,
                                    //       height: width * 0.15,
                                    //       decoration: BoxDecoration(
                                    //         image: DecorationImage(
                                    //           image: NetworkImage(widget
                                    //               .addedFriends[index].picURL),
                                    //           fit: BoxFit.cover,
                                    //         ),
                                    //         borderRadius:
                                    //             BorderRadius.circular(100),
                                    //         boxShadow: [
                                    //           new BoxShadow(
                                    //             color: Colors.black26,
                                    //             offset:
                                    //                 new Offset(0.0, -0.0001),
                                    //             blurRadius: 10.0,
                                    //             spreadRadius: 0.0002,
                                    //           )
                                    //         ],
                                    //       ),
                                    //     );
                                    //   }),
                                    // )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    RaisedButton(
                                      color: Colors.indigo,
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        //side: BorderSide(color: Colors.red)
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context,
                                            widget.addedFriends.length);
                                      },
                                      child: Text("Done!"),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      : Center(),
                ],
              ),
            ));
  } //end bulid

  bool checkAdded(String username) {
    bool added = false;
    if (widget.addedFriends.isNotEmpty) {
      widget.addedFriends.forEach((friend) {
        if (username.compareTo(friend.name) == 0) {
          added = true;
          return;
        } //end if
      });
    } // end if list not empty
    return added;
  }

  void _addToFriends(PeakUser user) {
    widget.addedFriends.add(user);
    setState(() {});
  }

  void _removeFromFriends(PeakUser user) {
    setState(() {
      var i;
      for (i = 0; i < widget.addedFriends.length; i++) {
        if (user.name.compareTo(widget.addedFriends[i].name) == 0) break;
      }
      widget.addedFriends.removeAt(i);
    });
  }
}

import 'package:flutter/material.dart';
import 'package:peak/models/badges.dart';
import 'package:peak/models/user.dart';
import 'package:peak/screens/shared/baseWithAppBar.dart';
import 'package:peak/viewmodels/addCompetitors_model.dart';
import 'package:stacked/stacked.dart';
import '../locator.dart';

class AddCompetitors extends StatefulWidget {
  List<PeakUser> addedFriends;
  AddCompetitors({this.addedFriends});
  @override
  _AddCompetitorsState createState() => _AddCompetitorsState();
}

class _AddCompetitorsState extends State<AddCompetitors> {
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
                    Navigator.pop(context);
                  }),
              childPadding: EdgeInsets.all(0),
              child: Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: model.users.length,
                      itemBuilder: (context, index) {
                        PeakUser currentUser = model.users[index];
                        return ListTile(
                          leading: Container(
                            padding: EdgeInsets.fromLTRB(
                                0.0, height * 0.008, 0.0, height * 0.008),
                            width: width * 0.15,
                            height: width * 0.15,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(currentUser.picURL),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.black26,
                                  offset: new Offset(0.0, -0.0001),
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
                        );
                      } //itemBuilder
                      ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Card(
                      color: Colors.grey[200],
                      elevation: 20,
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text("Compitiors"),
                              Wrap(
                                children: List<Widget>.generate(
                                    widget.addedFriends.length, (index) {
                                  return Container(
                                    padding: EdgeInsets.fromLTRB(0.0,
                                        height * 0.008, 0.0, height * 0.008),
                                    width: width * 0.15,
                                    height: width * 0.15,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            widget.addedFriends[index].picURL),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow: [
                                        new BoxShadow(
                                          color: Colors.black26,
                                          offset: new Offset(0.0, -0.0001),
                                          blurRadius: 10.0,
                                          spreadRadius: 0.0002,
                                        )
                                      ],
                                    ),
                                  );
                                }),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              RaisedButton(
                                onPressed: (){Navigator.pop(context);},
                                child: Text("Done!"),),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
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
      for ( i= 0; i < widget.addedFriends.length; i++) {
        if(user.name.compareTo(widget.addedFriends[i].name)==0)
         break;
      }
      widget.addedFriends.removeAt(i); 
    });
  }
}

import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:peak/locator.dart';
import 'package:peak/models/friends.dart';
import 'package:peak/models/user.dart';
import 'package:peak/screens/shared/custom_bottomNavigationBar.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/viewmodels/SearchForFriendModel.dart';
import 'package:peak/viewmodels/friendsList_model.dart';

class FriendSearch extends SearchDelegate<PeakUser> {
  
  setState(){

  }
  FriendsListModel friendsListModel = locator<FriendsListModel>();
  SearchForFriendModel searchModel = locator<SearchForFriendModel>();
  final _firstoreService = locator<DatabaseServices>();
  List<PeakUser> searchedUsers = [];

  double right;

  double top;

  List<PeakUser> loadSearchedUsers() {
    List<PeakUser> result = <PeakUser>[
      PeakUser(
          uid: '22',
          name: 'eman',
          picURL:
              "https://static0.cbrimages.com/wordpress/wp-content/uploads/2019/09/One-Piece-Monkey-D.-Luffy-Cropped.jpg"),
      PeakUser(
          uid: '22',
          name: 'hala',
          picURL:
              "https://static0.cbrimages.com/wordpress/wp-content/uploads/2019/09/One-Piece-Monkey-D.-Luffy-Cropped.jpg"),
      PeakUser(
          uid: '22',
          name: 'sara',
          picURL:
              "https://static0.cbrimages.com/wordpress/wp-content/uploads/2019/09/One-Piece-Monkey-D.-Luffy-Cropped.jpg")
    ];
    print(result);
    return result;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pushNamed(context, 'friendsList');
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    

    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    searchModel.readSearchedlist();
    final users = searchModel.users;
    List<PeakUser> filtiredUsers = [];

    for (var item in users) {
      if (item.name != null &&
          item.picURL != null &&
          item.name == query &&
          _firstoreService.getUser().uid != item.uid) filtiredUsers.add(item);
    }
    if(query.isNotEmpty && filtiredUsers.isNotEmpty){
    return ListView.builder(
        itemCount: filtiredUsers.length,
        itemBuilder: (context, index) {
          var user = filtiredUsers[index];
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
                      SizedBox(width: width * 0.03),
                      Text(
                        user.name,
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                      ),
                      Spacer(),
                      whichIcon(
                          context, _firstoreService.getUser().uid, user.uid,user),
                    ],
                  ),
                  leading: Container(
                    width: width * 0.15,
                    height: width * 0.15,
                    padding: EdgeInsets.fromLTRB(
                        0.0, height * 0.008, 0.0, height * 0.008),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(user.picURL),
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
                  onTap: () {
                    //Navigator.pushNamed(context, "goalDetails", arguments: goal);
                  },
                ),
              ));
        });}
          if (query.isEmpty) {
      return Column(
        children: [
          Padding(padding: const EdgeInsets.only(top: 150.0)),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text("Lets find some friend \n Enter a name",
                  style: TextStyle(fontSize: width * 0.07, color: Colors.grey),
                  textAlign: TextAlign.center),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.search_outlined,
                color: Colors.teal[100],
                size: 100,
              ),
            ),
          )
        ],
      );
    }
    if (query.isNotEmpty && filtiredUsers.isEmpty) {
      return Column(
        children: [
          Padding(padding: const EdgeInsets.only(top: 150.0)),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                "No Resuts...",
                style: TextStyle(fontSize: width * 0.07, color: Colors.grey),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.search_off,
                color: Colors.teal[100],
                size: 100,
              ),
            ),
          )
        ],
      );
    }

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    searchModel.readSearchedlist();
    final users = searchModel.users;
    List<PeakUser> filtiredUsers = [];
    List<bool> isFriend = [];

    for (var item in users) {
      if (item.name != null &&
          item.picURL != null &&
           item.name.contains(query)  &&
          _firstoreService.getUser().uid != item.uid)
           filtiredUsers.add(item);
    }

    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    if (query.isEmpty) {
      return Column(
        children: [
          Padding(padding: const EdgeInsets.only(top: 150.0)),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text("Lets find some friend \n Enter a name",
                  style: TextStyle(fontSize: width * 0.07, color: Colors.grey),
                  textAlign: TextAlign.center),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.search_outlined,
                color: Colors.teal[100],
                size: 100,
              ),
            ),
          )
        ],
      );
    }
    if (query.isNotEmpty && filtiredUsers.isEmpty) {
      return Column(
        children: [
          Padding(padding: const EdgeInsets.only(top: 150.0)),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                "No Resuts...",
                style: TextStyle(fontSize: width * 0.07, color: Colors.grey),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.search_off,
                color: Colors.teal[100],
                size: 100,
              ),
            ),
          )
        ],
      );
    }
    if (query.isNotEmpty && filtiredUsers.isNotEmpty) {
      return Container();
    //   return ListView.builder(
    //       itemCount: filtiredUsers.length,
    //       itemBuilder: (context, index) {
    //         var user = filtiredUsers[index];
    //        // Widget fIcon =whichIcon(context,_firstoreService.getUser().uid, user.uid,user);
    //         return Card(
    //             //card Property
    //             elevation: 20,
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(20.0),
    //             ),
    //             child: Padding(
    //               padding: EdgeInsets.all(width * 0.008),
    //               child: ListTile(
    //                 contentPadding: EdgeInsets.fromLTRB(
    //                     width * 0.05, height * 0.02, 0.0, height * 0.01),
    //                 title: Row(
    //                   children: [
    //                     SizedBox(width: width * 0.03),
    //                     Text(
    //                       user.name,
    //                       style: TextStyle(
    //                         color: Colors.black87,
    //                         fontWeight: FontWeight.w400,
    //                         fontSize: 18,
    //                       ),
    //                     ),
    //                     Spacer(),
    //                      whichIcon(
    //                        context, _firstoreService.getUser().uid, user.uid,user),
                       
    //                   ],
    //                 ),
    //                 leading: Container(
    //                   width: width * 0.15,
    //                   height: width * 0.15,
    //                   padding: EdgeInsets.fromLTRB(
    //                       0.0, height * 0.008, 0.0, height * 0.008),
    //                   decoration: BoxDecoration(
    //                     image: DecorationImage(
    //                       image: NetworkImage(user.picURL),
    //                       fit: BoxFit.cover,
    //                     ),
    //                     borderRadius: BorderRadius.circular(100),
    //                     boxShadow: [
    //                       new BoxShadow(
    //                         color: Colors.black26,
    //                         offset: new Offset(0.0, -8.0),
    //                         blurRadius: 40.0,
    //                         spreadRadius: 1.0,
    //                       )
    //                     ],
    //                   ),
    //                 ),
    //                 onTap: () {
    //                   //Navigator.pushNamed(context, "goalDetails", arguments: goal);
    //                 },
    //               ),
    //             ));
    //       });
    // }
  }}

  Widget whichIcon(BuildContext context, String uid1, String uid2, PeakUser user) {
  //  print(user.name);
  friendsListModel.readfriendslist();
    List<PeakUser> friend = friendsListModel.friends;
    bool isF = false;
    for (var item in friend) {
      if(item.uid== user.uid)
      isF=true;
    }
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
     print("Before");
   // searchModel.isFriends(uid1, uid2);
    print(isF);
    print(searchModel.isTheyFriends);
    if (isF)
      return Icon(
        Icons.person_add,
        size: 30,
        color: Colors.grey,
      );
    else
      return IconButton(
          padding: EdgeInsets.fromLTRB(0.0, height * 0.01, 0.0, height * 0.01),
          icon: Icon(
            Icons.person_add,
            size: 30,
          ),
          color: Colors.indigo[600],
          onPressed: () async {
           await searchModel.addFriend(uid1, uid2);
        //  Navigator.pop(context);
          
          });
  }
}

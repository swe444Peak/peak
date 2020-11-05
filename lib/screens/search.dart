import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:peak/locator.dart';
import 'package:peak/models/user.dart';
import 'package:peak/screens/shared/custom_bottomNavigationBar.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/viewmodels/SearchForFriendModel.dart';

class FriendSearch extends SearchDelegate<PeakUser> {
  SearchForFriendModel searchModel = locator<SearchForFriendModel>();
  final _firstoreService = locator<DatabaseServices>();
  List<PeakUser> searchedUsers = [];

//  List<PeakUser> loadSearchedUsers()  {
//   List<PeakUser> result=[];
//    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
//     result =  event.docs.map((e) => PeakUser.fromJson(e.data(), e.id)).toList();});
//     print (result);
//   return result;

//  }

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
    //   final users =  loadSearchedUsers();

    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    searchModel.readSearchedlist();

    final users = searchModel.users;
    List<PeakUser> filtiredUsers = [];

    for (var item in users) {
      if (item.name != null &&
          item.picURL != null &&
          item.name.contains(query) &&
          _firstoreService.getUser().uid != item.uid) filtiredUsers.add(item);
    }

    // filtiredUsers = filtiredUsers.where((element) => element.name.toLowerCase().contains(query))
    //         .toList();

    // final users = query.isEmpty
    //     ? searchModel.users
    //     : searchModel.users
    //         .where((element) => element.name.toLowerCase().contains(query))
    //         .toList();

    // final users = query.isEmpty? loadSearchedUsers() : loadSearchedUsers().where((element) => element.name.toLowerCase().contains(query)).toList();

    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    if (query.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            "Lets Find a Friend , Enter a name",
            style: TextStyle(fontSize: width * 0.06, color: Colors.indigo[600]),
          ),
        ),
      );
    }
    if (query.isNotEmpty && filtiredUsers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            "No resuts",
            style: TextStyle(fontSize: width * 0.06, color: Colors.indigo[600]),
          ),
        ),
      );
    }
    if (query.isNotEmpty && filtiredUsers.isNotEmpty) {
      return ListView.builder(
          itemCount: filtiredUsers.length,
          itemBuilder: (context, index) {
            var user = filtiredUsers[index];
            print(user.name);
            print(user.picURL);
            for (var item in filtiredUsers) {
              print(item.name);
            }

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
                        IconButton(
                            padding: EdgeInsets.fromLTRB(
                                0.0, height * 0.01, 0.0, height * 0.01),
                            icon: Icon(
                              Icons.person_add,
                              size: 30,
                            ),
                            color: Colors.indigo[600],
                            onPressed: () {
                              //searchModel.addFriend(user.uid, currentId); //neeed current id
                            }),
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
          });
    }

    // return users.isNotEmpty
    //     ? ListView.builder(
    //         itemCount: users.length,
    //         itemBuilder: (context, index) {
    //           var user = users[index];
    //           print(searchModel.users);
    //           return Card(
    //               //card Property
    //               elevation: 20,
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(20.0),
    //               ),
    //               child: Padding(
    //                 padding: EdgeInsets.all(width * 0.008),
    //                 child: ListTile(
    //                   contentPadding: EdgeInsets.fromLTRB(
    //                       width * 0.05, height * 0.02, 0.0, height * 0.01),
    //                   title: Row(
    //                     children: [
    //                       SizedBox(width: width * 0.03),
    //                       Text(
    //                         user.name,
    //                         style: TextStyle(
    //                           color: Colors.black87,
    //                           fontWeight: FontWeight.w400,
    //                           fontSize: 18,
    //                         ),
    //                       ),
    //                       Spacer(),
    //                       IconButton(
    //                           padding: EdgeInsets.fromLTRB(
    //                               0.0, height * 0.01, 0.0, height * 0.01),
    //                           icon: Icon(
    //                             Icons.person_add,
    //                             size: 30,
    //                           ),
    //                           color: Colors.indigo[600],
    //                           onPressed: () {}),
    //                     ],
    //                   ),
    //                   leading: Container(
    //                     width: width * 0.15,
    //                     height: width * 0.15,
    //                     padding: EdgeInsets.fromLTRB(
    //                         0.0, height * 0.008, 0.0, height * 0.008),
    //                     decoration: BoxDecoration(
    //                       image: DecorationImage(
    //                         image: NetworkImage(user.picURL),
    //                         fit: BoxFit.cover,
    //                       ),
    //                       borderRadius: BorderRadius.circular(100),
    //                       boxShadow: [
    //                         new BoxShadow(
    //                           color: Colors.black26,
    //                           offset: new Offset(0.0, -8.0),
    //                           blurRadius: 40.0,
    //                           spreadRadius: 1.0,
    //                         )
    //                       ],
    //                     ),
    //                   ),
    //                   onTap: () {
    //                     //Navigator.pushNamed(context, "goalDetails", arguments: goal);
    //                   },
    //                 ),
    //               ));
    //         })
    //     : Center(
    //         child: Padding(
    //           padding: const EdgeInsets.all(8),
    //           child: Text(
    //             "No Results",
    //             style: TextStyle(fontSize: width * 0.06, color: Colors.white),
    //           ),
    //         ),
    //       );
  }
}

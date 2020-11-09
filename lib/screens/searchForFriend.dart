import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/models/user.dart';
import 'package:peak/screens/shared/custom_bottomNavigationBar.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/viewmodels/SearchForFriendModel.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import '../locator.dart';

class SearchForFriend extends StatefulWidget {
  @override
  _SearchForFriendState createState() => _SearchForFriendState();
}

class _SearchForFriendState extends State<SearchForFriend> {
  TextEditingController _searchController = TextEditingController();
  final _firstoreService = locator<DatabaseServices>();
 SearchForFriendModel searchModel = locator<SearchForFriendModel>();
  Future resultsLoaded;
  List _allResults = [];
  List<PeakUser> _resultsList = [];

  SearchForFriendModel model = new SearchForFriendModel();
  List<PeakUser> searchedList= [];
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
 
    searchResultsList();
  }


  searchResultsList() {
   searchModel.readSearchedlist();
    final users = searchModel.users;
    List<PeakUser> filtiredUsers = [];
    for (var item in users) {
      if (item.name != null &&
          item.picURL != null &&
          item.name == _searchController.text &&
          _firstoreService.getUser().uid != item.uid) filtiredUsers.add(item);
    }


  }

  @override
  Widget build(BuildContext context) {
    // var userId = Provider.of<User>(context);
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    TextEditingController _searchController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor ,
          iconTheme: Theme.of(context).primaryIconTheme,
          textTheme:Theme.of(context).primaryTextTheme,
          brightness: Theme.of(context).primaryColorBrightness,
          leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pushNamed(context, 'friendsList');
        }),
          title: TextField(
            controller:_searchController,
           // focusNode: focusNode,
            style:  Theme.of(context).textTheme.headline6,
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.text,
            onSubmitted: (String _) {
             buildResults(context);
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Friend Name",
              hintStyle: Theme.of(context).textTheme.headline6,
            ),
          ),
          actions: [
              IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            _searchController.text = '';
          })
    ],
        ),
       
      body:AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: buildResults(context),
        )
    //  SingleChildScrollView(
          
    // //         child: Stack(children: [
    // //       Container(
    // //         width: width * 0.8,
    // //         height: width * 0.6,
    // //         margin: EdgeInsets.fromLTRB(0, 0.0, width * 0.2, 0.0),
    // //         decoration: BoxDecoration(
    // //             color: Colors.indigo[500],
    // //             borderRadius:
    // //                 BorderRadius.only(bottomRight: Radius.circular(400)),
    // //             gradient: LinearGradient(colors: [
    // //               Colors.teal[400],
    // //               Colors.indigo[600],
    // //               Colors.deepPurple[900]
    // //             ], begin: Alignment.topLeft, end: Alignment.bottomCenter)),
    // //       ),
    // //       Container(
    // //         padding: EdgeInsets.fromLTRB(
    // //             width * 0.06, height * 0.12, width * 0.06, 0.0),
    // //         child: Column(
    // //             mainAxisSize: MainAxisSize.min,
    // //             children: [
    // //           Row(
    // //             children: [
    // //               Padding(
    // //                 padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, (width * 0.1)),
    // //                 child: Text(
    // //                   "Search For Friend",
    // //                   style: TextStyle(
    // //                     color: Colors.white,
    // //                     fontSize: 34.0,
    // //                     fontWeight: FontWeight.w400,
    // //                   ),
    // //                 ),
    // //               ),
    // //             ],
    // //           ),
    // //           TextField(
    // //               controller: _searchController,
    // //               decoration: InputDecoration(prefixIcon: Icon(Icons.search))),
    // //           Padding(
    // //             padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, (width * 0.1)),
    // //           ),
    // //             Column(
    // //                mainAxisSize: MainAxisSize.min,
    // //               children: [
    // //                 Expanded(   
    // //         child: Column(
    // //           mainAxisSize: MainAxisSize.min,
    // //           children: [
    // //             ListView.builder(
                  
    // //                itemCount: searchedList.length,
    // //                     itemBuilder: (BuildContext context, int index) =>
    // //                         userCard(context,width,height, searchedList[index]),
    // //             ),
    // //           ],
    // //         )

    // //       ),
    // //               ],
    // //             ),
    // //          //  Flexible(child: searchedFriendsList(model, width, height)),
    // //         ]
    // //         ),
    // //       ),
    // //     ]))
    );
  }

  Widget userCard(context,width,height,user ){
        return Container(
          child: Card(
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
                          //SizedBox(width: width * 0.03),
                          Text(
                             user.name,
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
                                Icons.person_add,
                                size: 30,
                              ),
                              color: Colors.indigo[600],
                              onPressed: () {}),
                        ],
                      ),
                      onTap: () {
                        //Navigator.pushNamed(context, "goalDetails", arguments: goal);
                      },
                    ),
                  )),
        );
  }

  Widget searchedFriendsList(model,width,height) {
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
            "No Results",
            style: TextStyle(fontSize: width * 0.06, color: Colors.white),
          ),
        ),
      );
    }
  if (model.users != null) {
    print("THERE IS SOME USERS");
      return Column(
         mainAxisSize: MainAxisSize.min,
        children: [
          ListView.builder(
              itemCount: model.users.length,
              itemBuilder: (context, index) {
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
                              image: NetworkImage(_resultsList[index].picURL),
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
                           _resultsList[index].name,
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
                              Icons.person_add,
                              size: 30,
                            ),
                            color: Colors.indigo[600],
                            onPressed: () {}),
                      ],
                    ),
                    onTap: () {
                      //Navigator.pushNamed(context, "goalDetails", arguments: goal);
                    },
                  ),
                ));
          }),
        ],
      );
    }
    print(model.users);
    return Text("issue");
  }
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
          item.name == _searchController.text &&
          _firstoreService.getUser().uid != item.uid) filtiredUsers.add(item);
    }
    if(_searchController.text.isNotEmpty && filtiredUsers.isNotEmpty){
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
                      // whichIcon(
                      //     context, _firstoreService.getUser().uid, user.uid,user),
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
          if (_searchController.text.isEmpty) {
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
    if (_searchController.text.isNotEmpty && filtiredUsers.isEmpty) {
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

   Widget whichIcon(BuildContext context, String uid1, String uid2, PeakUser user) {
    var screenSize = MediaQuery.of(context).size;
  //  var width = screenSize.width;
    var height = screenSize.height;
    searchModel.isFriends(uid1, uid2);
    print(searchModel.isTheyFriends);
   if (searchModel.isTheyFriends)
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

          });
  }



}

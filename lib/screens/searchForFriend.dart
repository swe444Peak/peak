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
    search();
    searchResultsList();
  }

 search(){
  FirebaseFirestore.instance.collection('users').where('username',isEqualTo:_searchController.text ).snapshots().listen((event) {
  searchedList = event.docs.map((e) => PeakUser.fromJson(e.data(), e.id)).toList();
   });
   
 }
  searchResultsList() {
    _allResults = model.users;
    var showResults = [];
    if (_searchController.text != "") {
      for (var user in _allResults) {
        if (user.name == _searchController.text) showResults.add(user);
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    // var userId = Provider.of<User>(context);
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    TextEditingController _searchController = TextEditingController();
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
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        
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
                gradient: LinearGradient(colors: [
                  Colors.teal[400],
                  Colors.indigo[600],
                  Colors.deepPurple[900]
                ], begin: Alignment.topLeft, end: Alignment.bottomCenter)),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                width * 0.06, height * 0.12, width * 0.06, 0.0),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, (width * 0.1)),
                    child: Text(
                      "Search For Friend",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              TextField(
                  controller: _searchController,
                  decoration: InputDecoration(prefixIcon: Icon(Icons.search))),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, (width * 0.1)),
              ),
                Column(
                   mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(   
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.builder(
                  
                   itemCount: searchedList.length,
                        itemBuilder: (BuildContext context, int index) =>
                            userCard(context,width,height, searchedList[index]),
                ),
              ],
            )

          ),
                  ],
                ),
             //  Flexible(child: searchedFriendsList(model, width, height)),
            ]
            ),
          ),
        ])));
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


}

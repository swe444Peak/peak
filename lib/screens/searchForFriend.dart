import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peak/models/user.dart';
import 'package:peak/screens/shared/custom_bottomNavigationBar.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/viewmodels/SearchForFriendModel.dart';
import 'package:provider/provider.dart';

class SearchForFriend extends StatefulWidget {
  @override
  _SearchForFriendState createState() => _SearchForFriendState();
}

class _SearchForFriendState extends State<SearchForFriend> {
TextEditingController _searchController = TextEditingController();

 Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];

SearchForFriendModel model = new SearchForFriendModel();

 @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

 _onSearchChanged() {
    searchResultsList();
  }

 searchResultsList() {
   _allResults = model.users;
    var showResults = [];
    if(_searchController.text != "") {
     for (var user in _allResults) {
       if (user.name == _searchController.text)
    showResults.add(user);
      
     }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

//   getUsersStreamSnapshots() async {
//     final uid = await Provider.of(context).auth.getCurrentUID();
//     var data = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(uid)
//         .where("username", isLessThanOrEqualTo: DateTime.now())
//         .orderBy('endDate')
//         .getDocuments();
//     setState(() {
//       _allResults = data.documents;
//     });
//     searchResultsList();
//     return "complete";
//   }

  @override
  // Widget build(BuildContext context) {
  //  // var userId = Provider.of<User>(context);
  //   var screenSize = MediaQuery.of(context).size;
  //   var width = screenSize.width;
  //   var height = screenSize.height;
  //   TextEditingController _searchController = TextEditingController();
  //   return StreamProvider<PeakUser>.value(
  //       initialData: PeakUser(uid: "", name: ""),
  //       value: DatabaseServices().usesnapshotrData(userId?.uid),
  //       builder: (context, ) {
  //         return Scaffold(
  //             extendBodyBehindAppBar: true,
  //             backgroundColor: Color.fromRGBO(23, 23, 85, 1.0),
  //             bottomNavigationBar: CustomNavigationBar(3),
  //             floatingActionButton: FloatingActionButton(
  //               onPressed: () {
  //                 Navigator.pushNamed(context, 'addNewGoal');
  //               },
  //               child: Icon(Icons.add),
  //               backgroundColor: Colors.teal[400],
  //             ),
  //             floatingActionButtonLocation:
  //                 FloatingActionButtonLocation.endDocked,
  //             body: SingleChildScrollView(
  //                 child: Stack(children: [
  //               Container(
  //                 width: width * 0.8,
  //                 height: width * 0.6,
  //                 margin: EdgeInsets.fromLTRB(0, 0.0, width * 0.2, 0.0),
  //                 decoration: BoxDecoration(
  //                     color: Colors.indigo[500],
  //                     borderRadius:
  //                         BorderRadius.only(bottomRight: Radius.circular(400)),
  //                     gradient: LinearGradient(
  //                         colors: [
  //                           Colors.teal[400],
  //                           Colors.indigo[600],
  //                           Colors.deepPurple[900]
  //                         ],
  //                         begin: Alignment.topLeft,
  //                         end: Alignment.bottomCenter)),
  //               ),
  //               Container(
  //                 padding: EdgeInsets.fromLTRB(
  //                     width * 0.06, height * 0.12, width * 0.06, 0.0),
  //                 child: Column(children: [
  //                   Row(
  //                     children: [
  //                       Padding(
  //                         padding:
  //                             EdgeInsets.fromLTRB(0.0, 0.0, 0.0, (width * 0.1)),
  //                         child: Text(
  //                           "Search For Friend",
  //                           style: TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 34.0,
  //                             fontWeight: FontWeight.w400,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   TextField(
  //                       controller: _searchController,
  //                       decoration:
  //                           InputDecoration(prefixIcon: Icon(Icons.search))),
  //                   Padding(
  //                     padding:
  //                         EdgeInsets.fromLTRB(0.0, 0.0, 0.0, (width * 0.1)),
  //                   ),
  //                   Card(
  //                     //card Property
  //                     elevation: 20,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(20.0),
  //                     ),

  //                     child: ListTile(
  //                       contentPadding: EdgeInsets.fromLTRB(width * 0.05,
  //                           height * 0.01, width * 0.05, height * 0.01),
  //                       title: Row(
  //                         children: [
  //                           Container(
  //                             width: width * 0.15,
  //                             height: width * 0.15,
  //                             decoration: BoxDecoration(
  //                               image: DecorationImage(
  //                                 image: NetworkImage(
  //                                     "https://static0.cbrimages.com/wordpress/wp-content/uploads/2019/09/One-Piece-Monkey-D.-Luffy-Cropped.jpg"),
  //                                 fit: BoxFit.cover,
  //                               ),
  //                               borderRadius: BorderRadius.circular(100),
  //                               boxShadow: [
  //                                 new BoxShadow(
  //                                   color: Colors.black26,
  //                                   offset: new Offset(0.0, -8.0),
  //                                   blurRadius: 40.0,
  //                                   spreadRadius: 1.0,
  //                                 )
  //                               ],
  //                             ),
  //                           ),
  //                           SizedBox(width: width * 0.03),
  //                           Text(
  //                             "Monkey",
  //                             style: TextStyle(
  //                               color: Colors.black87,
  //                               fontWeight: FontWeight.w400,
  //                               fontSize: 18,
  //                             ),
  //                           ),
  //                           Spacer(),
  //                           Icon(
  //                             Icons.person_add,
  //                             color: Color.fromRGBO(23, 23, 85, 1.0),
  //                             size: 30,
  //                           ),
  //                         ],
  //                       ),
  //                       onTap: () {
  //                         //Navigator.pushNamed(context, "goalDetails", arguments: goal);
  //                         //  Navigator.pushNamed(context, "searchForFriend");
  //                       },
  //                     ),
  //                   ),
  //                 ]),
  //               ),
  //             ])));
  //       });
  // }
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
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
              Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search)
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _resultsList.length,
                itemBuilder: (context, index) =>
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
                            SizedBox(width: width * 0.03),
                            Text(
                              _resultsList[index],
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.person_add,
                              color: Color.fromRGBO(23, 23, 85, 1.0),
                              size: 30,
                            ),
                          ],
                        ),
                        onTap: () {
                         
                        },
                      ),
                    ),
               )

              ),
              ],
            ),
              )
              ])
              )
              );
             }
             }

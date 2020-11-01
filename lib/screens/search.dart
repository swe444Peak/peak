import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:peak/models/user.dart';
import 'package:peak/screens/shared/custom_bottomNavigationBar.dart';

class Search extends StatefulWidget {
  @override
  _Search createState() => _Search();
  }
  
  class _Search extends State<Search> {
  @override
  Widget build(BuildContext context) {
      var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    TextEditingController _searchController = TextEditingController();
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Color.fromRGBO(23, 23, 85, 1.0),
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
    
}

class FriendSearch extends SearchDelegate<PeakUser>{
  @override
  List<Widget> buildActions(BuildContext context) {
     return [
     IconButton(icon:Icon(Icons.clear),
      onPressed:() {})
     ]; 
     
    }
  
    @override
    Widget buildLeading(BuildContext context) {
      return IconButton(icon: Icon(Icons.arrow_back),
       onPressed: (){

       });
       
    }
  
    @override
    Widget buildResults(BuildContext context) {
      return Container();
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {
     return Container();
  }

}
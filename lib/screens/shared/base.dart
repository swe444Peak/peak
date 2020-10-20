import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_bottomNavigationBar.dart';

class Base extends StatelessWidget {
  String title;
  Widget child;
  List<Widget> actions;
  Base({this.title, this.child, this.actions});
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Color.fromRGBO(23, 23, 85, 1.0),
        /*bottomNavigationBar: CustomNavigationBar(1),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, 'addNewGoal');
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.teal[400],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,*/
        body: Stack(
          children: [
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
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, height * 0.09, 0, 0.0),
                    child: AppBar(
                      title: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      actions: actions,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.fromLTRB(width * 0.06, 0, width * 0.06, 0.0),
                    child: child,
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

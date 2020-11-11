import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_bottomNavigationBar.dart';

class BaseWithAppBar extends StatelessWidget {
  String title;
  Widget child;
  List<Widget> actions;
  EdgeInsets childPadding;
  Widget leading;
  BaseWithAppBar(
      {this.title, this.child, this.actions, this.childPadding, this.leading});
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
                      leading: leading,
                      title: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      actions: actions,
                    ),
        extendBodyBehindAppBar: true,
        backgroundColor: Color.fromRGBO(23, 23, 85, 1.0),
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
              height: height, ////////edit here if height is so small
              child:
                  SingleChildScrollView(
                                      child: Padding(
                      padding: childPadding,
                      child: child,
                    ),
                  )
            ),
          ],
        ));
  }
}

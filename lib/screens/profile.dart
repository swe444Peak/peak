import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:peak/screens/custom_bottomNavigationBar.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/models/user.dart';


class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    //User user;

    return StreamProvider<PeakUser>.value(
          value: DatabaseServices().userData,
          builder: (context, snapshot){
                      return Scaffold(

        extendBodyBehindAppBar: true,
        backgroundColor: Color.fromRGBO(23, 23, 85, 1.0),

        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: Padding(padding: EdgeInsets.only(top: 0.0)),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ), 
                onPressed: (){
                  Navigator.pushNamed(context, 'settings');
                })
            ],
        ),

        //common
        bottomNavigationBar: CustomNavigationBar(1),
        floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.add),
            backgroundColor: Colors.teal[400],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        //end common

      body: SingleChildScrollView(
        child: Stack(
            children: [
              Container(
                width: width,
                height: height*0.32,
                //margin: EdgeInsets.fromLTRB(0, 0.0, 0.0, 0.0),
                decoration: BoxDecoration(
                  //color: Colors.indigo[500],
                  borderRadius: BorderRadius.vertical(bottom:Radius.circular(200))/*.only(bottomLeft: Radius.circular(150))*/,
                  gradient: LinearGradient(
                    colors: [Colors.teal[400],Colors.indigo[600],Colors.deepPurple[900]],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)
                ),
              ),

              /*Container(
                width: width,
                height: height-(width*0.5),
                margin: EdgeInsets.fromLTRB(0.0, (width*0.25), 0.0, 0.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.black26,
                      offset: new Offset(0.0, -8.0),
                      blurRadius: 40.0,
                      spreadRadius: 1.0,
                )
                  ],
                  color: Color.fromRGBO(23, 23, 85, 1.0),
                  borderRadius: BorderRadius.vertical(top:Radius.circular(50)),
                  ),
              ),*/


              Padding(
                padding: EdgeInsets.only(top: (height*0.03)),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        width: width*0.4,
                        height: width*0.4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                          image: AssetImage('assets/profile_default.png'),
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${Provider.of<PeakUser>(context)?.name}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
                ),
              
            ],
        ),
      ),

      );
          }
    );
  }
}
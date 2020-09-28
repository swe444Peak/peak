import 'package:flutter/material.dart';
import 'package:peak/screens/shared/commonStyle.dart';

class NewGoalPage extends StatefulWidget {
  @override
  _NewGoalPageState createState() => _NewGoalPageState();
}

class _NewGoalPageState extends State<NewGoalPage> {
  TextEditingController _goalnamecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromRGBO(23, 23, 85, 1.0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Stack(
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
              padding: EdgeInsets.fromLTRB(
                  width * 0.06, height * 0.12, width * 0.06, 0.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.fromLTRB(0.0, 0.0, 0.0, (width * 0.06)),
                        child: Text(
                          "Add A New Goal",
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
                    //Account
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: size.height * 0.06),
                          TextField(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

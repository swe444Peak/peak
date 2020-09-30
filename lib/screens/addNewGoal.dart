import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/models/user.dart';
import 'package:peak/screens/shared/commonStyle.dart';
import 'package:peak/screens/shared/customButton.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/viewmodels/createGoal_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../locator.dart';
import 'DynamicTasks.dart';

class NewGoalPage extends StatefulWidget {
  @override
  _NewGoalPageState createState() => _NewGoalPageState();
}

class _NewGoalPageState extends State<NewGoalPage> {
  String _error;
  TextEditingController _goalnamecontroller = TextEditingController();
  DateTime _dateTime;
  List<String> numbers = ['1', '2', '3', '4', '5'];
  String _selectedNum;

  //List<DynamicTasks> dynamicList = [];
  //List<String> tasks = [];

  @override
  void dispose() {
    _goalnamecontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var user = Provider.of<User>(context);
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return StreamProvider<PeakUser>.value(
        initialData: PeakUser(uid: "", name: ""),
        value: DatabaseServices().userData(user.uid),
        builder: (context, snapshot) {
          return ChangeNotifierProvider<CreateGoalModel>(
            create: (context) => locator<CreateGoalModel>(),
            child: Consumer<CreateGoalModel>(
              builder: (context, model, child) => SafeArea(
                child: Scaffold(
                  backgroundColor: Color.fromRGBO(23, 23, 85, 1.0),
                  extendBodyBehindAppBar: true,
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
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(400)),
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
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0.0, 0.0, 0.0, (width * 0.06)),
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
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  child: Column(
                                    children: [
                                      showAlert(),
                                      SizedBox(height: size.height * 0.06),
                                      buildTextFiled(
                                          _goalnamecontroller,
                                          false,
                                          "Goal name",
                                          model.goalName.error,
                                          model.setGoalName),
                                      SizedBox(height: size.height * 0.03),
                                      Row(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text("Goal\'s deadline:   ",
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 20.0,
                                                    color: Color.fromRGBO(
                                                        23, 23, 85, 1.0)),
                                                textAlign: TextAlign.left),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                _dateTime == null
                                                    ? '  '
                                                    : DateFormat('dd-MM-yyyy')
                                                        .format(_dateTime),
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 20.0,
                                                    color: Color.fromRGBO(
                                                        23, 23, 85, 1.0)),
                                                textAlign: TextAlign.left),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: size.height * 0.02),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(50, 0, 50, 0),
                                        child: Card(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.calendar_today,
                                              color: Color.fromRGBO(
                                                  23, 23, 85, 1.0),
                                              size: 30,
                                            ),
                                            title: Text(
                                              "Pick a date",
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    23, 23, 85, 1.0),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 19,
                                              ),
                                            ),
                                            onTap: () async {
                                              showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          _dateTime == null
                                                              ? DateTime.now()
                                                              : _dateTime,
                                                      firstDate: DateTime(2020),
                                                      lastDate: DateTime(2120))
                                                  .then((date) {
                                                setState(() {
                                                  _dateTime = date;
                                                });
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.04),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.teal[300],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              20, 10, 20, 10),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Tasks :",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 30,
                                                    ),
                                                  ),
                                                  ClipOval(
                                                    child: Material(
                                                      color: Colors
                                                          .white, // button color
                                                      child: InkWell(
                                                        splashColor: Colors
                                                            .teal, // inkwell color
                                                        child: SizedBox(
                                                            width: 56,
                                                            height: 56,
                                                            child: Icon(
                                                                Icons.add)),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.03),
                                      DropdownButton(
                                        hint: Text('Number of tasks per day'),
                                        value: _selectedNum,
                                        onChanged: (newValue) {
                                          setState(() {
                                            _selectedNum = newValue;
                                          });
                                        },
                                        items: numbers.map((number) {
                                          return DropdownMenuItem(
                                            child: new Text(number,
                                                textAlign: TextAlign.center),
                                            value: number,
                                          );
                                        }).toList(),
                                      ),
                                      SizedBox(height: size.height * 0.03),
                                      ButtonTheme(
                                        minWidth: 100.0,
                                        height: 50.0,
                                        child: RaisedButton(
                                          splashColor: Colors.teal,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                          ),
                                          color:
                                              Color.fromRGBO(23, 23, 85, 1.0),
                                          onPressed: () {},
                                          textColor: Colors.white,
                                          child: Text('Add',
                                              style: TextStyle(fontSize: 19.0)),
                                        ),
                                      ),
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
                ),
              ),
            ),
          );
        });
  }

  Widget showAlert() {
    if (_error != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: Text(_error),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _error = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }
}

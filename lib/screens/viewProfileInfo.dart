import 'package:flutter/material.dart';
import 'package:peak/screens/viewBadges.dart';
import 'package:peak/screens/viewProgress.dart';
// import 'package:toggle_bar/toggle_bar.dart';
import 'shared/toggleBar.dart';

class ProfileInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ProfileInfoState();
}

class ProfileInfoState extends State<ProfileInfo> {
  int tab;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return ListView(
      padding: EdgeInsets.all(0.0),
      children: [
        ToggleBar(
            labels: ["My Progress", "My Badges"],
            onSelectionUpdated: (index) => _onChange(index),
            backgroundColor: Colors.white,
            selectedTabColor: Colors.lightBlue[900],
            selectedTextColor: Colors.white,
            textColor: Colors.lightBlue[900],
            labelTextStyle: TextStyle(
            )),
        (tab == 0 ? ViewProgress() : ViewBadges()),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    tab = 0;
  }

  _onChange(int index) {
    setState(() {
      tab = index;
    });
  }
}

import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';

class CustomNavigationBar extends StatelessWidget {
  final int Index;

  /*void changePage(int index) {
    switch(index){
      case 0:
              () async {
                              var success = await LogoutMaodel().logout();
                              Navigator.pushNamed(context, 'login');
                            };
      case 1:
      case 2:
    }
  }*/

  CustomNavigationBar(this.Index);

  @override
  Widget build(BuildContext context) {
    return BubbleBottomBar(
      elevation: 50,
      hasNotch: true,
      fabLocation: BubbleBottomBarFabLocation.end,
      opacity: 0.15,
      backgroundColor: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      currentIndex: Index,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/');
            break;
          case 1:
            Navigator.pushNamed(context, 'goalsList');
            break;
          case 2:
            Navigator.pushNamed(context, 'profile');
            break;
          case 3:
            Navigator.pushNamed(context, 'friendsList');
            break;
        }
      },
      items: <BubbleBottomBarItem>[
        BubbleBottomBarItem(
            backgroundColor: Colors.teal,
            icon: Icon(
              Icons.home,
              color: Colors.black87,
            ),
            activeIcon: Icon(
              Icons.home,
              color: Colors.teal,
            ),
            title: Text("Home")),
        BubbleBottomBarItem(
            backgroundColor: Colors.indigoAccent,
            icon: Icon(
              Icons.storage,
              color: Colors.black87,
            ),
            activeIcon: Icon(
              Icons.storage,
              color: Colors.indigoAccent,
            ),
            title: Text("Goals List")),
        BubbleBottomBarItem(
            backgroundColor: Colors.cyan,
            icon: Icon(
              Icons.person_pin,
              color: Colors.black87,
            ),
            activeIcon: Icon(
              Icons.person_pin,
              color: Colors.cyan,
            ),
            title: Text("Profile")),
        BubbleBottomBarItem(
            backgroundColor: Colors.blue,
            icon: Icon(
              Icons.people,
              color: Colors.black87,
            ),
            activeIcon: Icon(
              Icons.people,
              color: Colors.blue,
            ),
            title: Text("Friends")),
      ],
    );
  }
}

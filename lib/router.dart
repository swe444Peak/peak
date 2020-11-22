import 'package:flutter/material.dart';
import 'package:peak/screens/FriendProfile.dart';
import 'package:peak/screens/addCompetitors.dart';
import 'package:peak/screens/addGoal.dart';
import 'package:peak/screens/editGoal.dart';
import 'package:peak/screens/editProfile.dart';
import 'package:peak/screens/forgoPassword.dart';
import 'package:peak/screens/friendsList.dart';
import 'package:peak/screens/goalDetails.dart';
import 'package:peak/screens/goalInvitations.dart';
import 'package:peak/screens/home.dart';
import 'package:peak/screens/search.dart';
import 'package:peak/screens/searchForFriend.dart';
import 'package:peak/screens/settings.dart';
import 'package:peak/screens/profile.dart';
import 'package:peak/screens/goalsList.dart';
import 'package:peak/screens/signUp.dart';
import 'screens/goalsList.dart';
import 'screens/login.dart';

const String initialRoute = "login";

class Routerr {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      case 'login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case 'goalsList':
        return MaterialPageRoute(builder: (_) => GoalsListPage());
      case 'editGoal':
        var goal = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => EditGoal(
                  goal: goal,
                ));
      case 'goalDetails':
        Map arguments = settings.arguments;
        var goal = arguments['goal'];
        var receive = arguments['receive'];
        return MaterialPageRoute(
            builder: (_) => GoalDetails(goal: goal, receive: receive));
      case 'addCompetitors':
        var friendsList = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => AddCompetitors(
                  addedFriends: friendsList,
                ));
      case 'addNewGoal':
        return MaterialPageRoute(builder: (_) => NewGoal());
      case 'settings':
        return MaterialPageRoute(builder: (_) => SettingsPage());
      case 'profile':
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case 'signUp':
        return MaterialPageRoute(builder: (_) => SignupPage());
      case 'editProfile':
        return MaterialPageRoute(builder: (_) => EditProfile());
      case 'forgotPassword':
        return MaterialPageRoute(builder: (_) => ForgotPasswordPage());
      case 'friendsList':
        return MaterialPageRoute(builder: (_) => FriendsList());
      case 'goalInvitations':
        return MaterialPageRoute(builder: (_) => GoalInvitations());
      case 'FriendProfile':
        var friend = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => FriendProfile(
                  friend: friend,
                ));
    }
  }
}

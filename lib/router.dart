import 'package:flutter/material.dart';
import 'package:peak/screens/forgoPassword.dart';
import 'package:peak/screens/home.dart';
import 'package:peak/screens/settings.dart';
import 'package:peak/screens/profile.dart';
import 'package:peak/screens/goalsList.dart';
import 'package:peak/screens/signUp.dart';
import 'screens/goalsList.dart';
import 'screens/login.dart';
import 'screens/addNewGoal.dart';

const String initialRoute = "login";

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      case 'login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case 'goalsList':
        return MaterialPageRoute(builder: (_) => GoalsListPage());
      case 'addNewGoal':
        return MaterialPageRoute(builder: (_) => NewGoalPage());
      case 'settings':
        return MaterialPageRoute(builder: (_) => SettingsPage());
      case 'profile':
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case 'signUp':
        return MaterialPageRoute(builder: (_) => SignupPage());
      case 'forgotPassword':
        return MaterialPageRoute(builder: (_) => ForgotPasswordPage());
    }
  }
}

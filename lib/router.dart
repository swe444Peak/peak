import 'package:flutter/material.dart';
import 'package:peak/screens/home.dart';
import 'package:peak/screens/signUp.dart';

import 'screens/login.dart';

const String initialRoute = "login";

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      case 'login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case 'signUp':
        return MaterialPageRoute(builder: (_) => SignupPage());
    }
  }
}

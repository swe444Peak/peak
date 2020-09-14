import 'package:flutter/material.dart';
import 'package:peak/screens/home.dart';

import 'screens/login.dart';

const String initialRoute = "login";

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      case 'login':
        return MaterialPageRoute(builder: (_) => LoginPage());
    }
  }
}

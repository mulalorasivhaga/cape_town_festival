import 'package:ct_festival/shared/navigation/view/main_nav.dart';
import 'package:flutter/material.dart';
import 'package:ct_festival/features/auth_screens/view/login_view.dart';
import 'package:ct_festival/features/auth_screens/view/reg_view.dart';

class Routes {
  // Define route names as constants
  static const String initial = '/MainNav';  // initial route
  static const String login = '/_handleRegistration';
  static const String register = '/registerView';

  // Define route generation
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      initial: (context) => MainNav(),  // initial screen
      login: (context) => const LoginScreen(),
      register: (context) => const RegScreen(),
    };
  }
}

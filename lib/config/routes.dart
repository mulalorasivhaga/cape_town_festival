import 'package:ct_festival/shared/navigation/view/main_nav.dart';
import 'package:flutter/material.dart';
import 'package:ct_festival/features/login_screen/view/login_view.dart';
import 'package:ct_festival/features/reg_screen/view/reg_view.dart';

class Routes {
  // Define route names as constants
  static const String initial = '/MainNav';  // initial route
  static const String login = '/loginView';
  static const String register = '/registerView';

  // Define route generation
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      initial: (context) => MainNav(),  // initial screen
      login: (context) => const LoginView(),
      register: (context) => const RegView(),
    };
  }
}

import 'package:ct_festival/features/analytics_screen/views/analytics_centre.dart';
import 'package:ct_festival/features/events_screen/view/events_screen.dart';
import 'package:ct_festival/features/home_screen/view/home_view.dart';
import 'package:ct_festival/shared/navigation/view/main_nav.dart';
import 'package:flutter/material.dart';
import 'package:ct_festival/features/auth_screens/view/login_view.dart';
import 'package:ct_festival/features/auth_screens/view/reg_view.dart';
import 'package:ct_festival/features/dashboard_screen/user/view/user_dashboard_view.dart';
import 'package:ct_festival/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Routes {
  // Define route names as constants
  static const String initial = '/MainNav';
  static const String home = '/home';
  static const String login = '/loginView';
  static const String register = '/registerView';
  static const String dashboard = '/dashboard';
  static const String events = '/events';
  static const String analytics = '/analytics';
  static const String analyticsCentre = '/analyticsCentre';



  // Define route generation
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      initial: (context) => MainNav(),  // initial screen
      home: (context) => HomeView(),  // home screen
      login: (context) => const LoginScreen(),
      register: (context) => const RegScreen(),
      events: (context) => const EventsScreen(),
      analyticsCentre: (context) => AnalyticsCentre(),
      dashboard: (context) => ProviderScope(
        child: Consumer(
          builder: (context, ref, child) {
            final user = ref.watch(authProvider);
            if (user != null) {
              return UserDashboard();
            } else {
              return LoginScreen();
            }
          },
        ),
      ),
    };
  }
}
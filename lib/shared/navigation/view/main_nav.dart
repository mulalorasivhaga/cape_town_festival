import 'package:ct_festival/features/dashboard_screen/view/admin_dashboard_view.dart';
import 'package:ct_festival/features/auth_screens/view/login_view.dart';
import 'package:ct_festival/features/auth_screens/view/reg_view.dart';
import 'package:ct_festival/features/event_screens/view/event_view.dart';
import 'package:flutter/material.dart';
import 'package:ct_festival/features/home_screen/view/home_view.dart';
import 'package:ct_festival/utils/logger.dart';

class MainNav extends StatelessWidget {
  // Create an instance of the logger
  final AppLogger logger = AppLogger();

  MainNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
                //logger.logInfo("Drawer opened");
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFAD343E)),
              child: Image(
                image: AssetImage('assets/logo/ct_logo.png'),
              ),
            ),
            ListTile(
              title: const Text('Events', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFAD343E)),),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EventView()),
                );
              },
            ), //events
            ListTile(
              title: const Text('Register'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegScreen()),
                );
              },
            ), //register
            ListTile(
              title: const Text('Login'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ), //login
            ListTile(
              title: const Text('Admin'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  AdminDashboardView()),
                );
              },
            ), //admin

          ],
        ),
      ),
      body: const HomeView(),
    );
  }
}

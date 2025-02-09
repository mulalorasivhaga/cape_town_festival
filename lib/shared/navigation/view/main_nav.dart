import 'package:ct_festival/features/auth_screens/view/login_view.dart';
import 'package:ct_festival/features/auth_screens/view/reg_view.dart';
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
              title: const Text('Register'),
              onTap: () {
                //logger.logInfo("Register menu item clicked");
                // Log navigation action
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Login'),
              onTap: () {
                //logger.logInfo("Login menu item clicked");
                // Log navigation action
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: const HomeView(),
    );
  }
}

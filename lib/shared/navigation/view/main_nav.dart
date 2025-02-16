import 'package:ct_festival/features/auth_screens/view/login_view.dart';
import 'package:ct_festival/features/auth_screens/view/reg_view.dart';
import 'package:ct_festival/features/dashboard_screen/user/view/user_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:ct_festival/features/home_screen/view/home_view.dart';
import 'package:ct_festival/utils/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct_festival/features/auth_screens/controller/auth_service.dart';

class MainNav extends StatelessWidget {
  final AppLogger logger = AppLogger();
  final AuthService authService = AuthService(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );

  MainNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE0E0CE),
        title: const Text(''),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('My Account'),
              onTap: () {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserDashboard()),
                  );
                }
              },
            ),
            ListTile(
              title: const Text('Admin'),
              onTap: () => authService.checkAdmin(context),
            ),
          ],
        ),
      ),
      body: const HomeView(),
    );
  }
}
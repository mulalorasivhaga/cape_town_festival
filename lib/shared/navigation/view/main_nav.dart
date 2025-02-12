import 'package:ct_festival/features/dashboard_screen/view/admin_dashboard_view.dart';
import 'package:ct_festival/features/auth_screens/view/login_view.dart';
import 'package:ct_festival/features/auth_screens/view/reg_view.dart';
import 'package:ct_festival/features/event_screens/view/event_view.dart';
import 'package:flutter/material.dart';
import 'package:ct_festival/features/home_screen/view/home_view.dart';
import 'package:ct_festival/utils/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainNav extends StatelessWidget {
  final AppLogger logger = AppLogger();

  MainNav({super.key});

  //function to check if the user is an admin
  Future<void> _checkAdmin(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!context.mounted) return; // Ensure context is still valid
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      return;
    }

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    // Check if user is admin
    if (!userDoc.exists || userDoc.data()?['role'] != 'admin') {
      if (!context.mounted) return; // Check if context is still valid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This link is only for admin, not permitted for users')),
      );
      return;
    }

    if (!context.mounted) return; // Check before navigation
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminDashboardView()),
    );
  }
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
            ),
            ListTile(
              title: const Text('Register'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Login'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Admin'),
              onTap: () => _checkAdmin(context),
            ),
          ],
        ),
      ),
      body: const HomeView(),
    );
  }
}
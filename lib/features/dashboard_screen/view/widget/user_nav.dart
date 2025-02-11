import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../auth_screens/view/login_view.dart';

class UserNavBar extends StatelessWidget {
  const UserNavBar({super.key});

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation",
              style: TextStyle(color: Colors.black)),
          content: const Text("Are you sure you want to log out?",
              style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Colors.black),
              ),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                  );
                }
              },
              child: const Text(
                "Log out",
                style: TextStyle(
                  color: Color(0xFFAD343E),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: screenHeight * 0.10,
      backgroundColor: Colors.transparent,
      title: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 0, top: 10, bottom: 5),
                child: Tooltip(
                  message: 'Click to log out',
                  child: GestureDetector(
                    onTap: () => _showLogoutConfirmation(context),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: const Icon(
                        Icons.lock,
                        color: Color(0xFFE2AF29),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
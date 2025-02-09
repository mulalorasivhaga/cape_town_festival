import 'package:ct_festival/features/user_dashboard/view/profile_dialog.dart';
import 'package:ct_festival/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../../shared/navigation/view/back_button.dart';
import '../../auth_screens/view/login_view.dart';

class UserDashboard extends StatelessWidget {
  // Logger instance
  final AppLogger logger = AppLogger();
  UserDashboard({super.key});

  /// Get the current user from Firestore
  Future<firebase_auth.User?> _getCurrentUser() async {
    try {
      logger.logInfo('🔍 Fetching current user...');
      final firebase_auth.User? firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        logger.logWarning('⚠️ No authenticated user found');
        return null;
      }

      logger.logInfo('✅ User data retrieved successfully');
      return firebaseUser;
    } catch (e) {
      logger.logError('❌ Error fetching user data: $e');
      return null;
    }
  }

  /// function to show the profile dialog
  void _showProfileDialog(BuildContext context) async {
    try {
      logger.logInfo('🔄 Opening profile view dialog...');
      final currentUser = await _getCurrentUser();

      if (currentUser != null && context.mounted) {
        logger.logInfo('👤 Showing profile for user: ${currentUser.email}');
        _showDialog(context, ProfileDialog(currentUser: currentUser));
      } else if (context.mounted) {
        logger.logWarning('⚠️ User not authenticated, redirecting to login');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      logger.logError('❌ Error showing profile dialog: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load profile')),
        );
      }
    }
  }

  /// function to show customized dialog box
  void _showDialog(BuildContext context, Widget dialogContent) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: const Color(0xFFAD343E),
            borderRadius: BorderRadius.circular(15),
          ),
          child: dialogContent,
        ),
      ),
    );
  }

  /// Build the user dashboard
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO: Resolve the issue with the PreferredSize widget, user must log out of dashboard
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: BackToHomeNav(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
        child: Center(
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 24.0,
              mainAxisSpacing: 24.0,
              childAspectRatio: 1.5, // Adjust this value to control card height
              mainAxisExtent: 300, // Fixed height for each card
            ),
            children: [
              _buildCard(
                title: 'View\nProfile',
                onTap: () => _showProfileDialog(context),
                color: const Color(0xFFAD343E),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the card widget
  Widget _buildCard({
    required String title,
    required VoidCallback onTap,
    required Color color,
    bool isDisabled = false,
  }) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Color(0xFFAD343E)
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
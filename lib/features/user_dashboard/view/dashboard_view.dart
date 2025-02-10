import 'package:ct_festival/features/user_dashboard/view/profile_dialog.dart';
import 'package:ct_festival/utils/logger.dart';
import 'package:flutter/material.dart';
import '../../auth_screens/view/login_view.dart';
import '../../user_dashboard/controller/user_profile_service.dart';
import 'package:ct_festival/features/user_dashboard/view/user_nav.dart';

class UserDashboard extends StatelessWidget {
  // Logger instance
  final AppLogger logger = AppLogger();
  final UserProfileService _userProfileService = UserProfileService();

  UserDashboard({super.key});

  /// function to show the profile dialog
  void _showProfileDialog(BuildContext context) async {
    try {
      logger.logInfo('🔄 Opening profile view dialog...');
      final userProfile = await _userProfileService.getUserProfile();

      if (userProfile != null && context.mounted) {
        logger.logInfo('👤 Showing profile for user: ${userProfile['email']}');
        _showDialog(context, ProfileDialog(currentUser: userProfile));
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: UserNavBar(),
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
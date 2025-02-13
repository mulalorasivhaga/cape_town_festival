import 'package:ct_festival/features/dashboard_screen/controller/user_profile_service.dart';
import 'package:ct_festival/features/dashboard_screen/view/widget/create_event_dialog.dart';
import 'package:ct_festival/features/dashboard_screen/view/widget/edit_event_dialog.dart';
import 'package:flutter/material.dart';
import '../../../auth_screens/view/login_view.dart';
import '../widget/profile_dialog.dart';
import 'package:ct_festival/utils/logger.dart';

mixin DashboardMixin {
  final AppLogger logger = AppLogger();
  final UserProfileService _userProfileService = UserProfileService();

  /// Function to show the profile dialog
  void showProfileDialog(BuildContext context) async {
    try {
      final userProfile = await _userProfileService.getUserProfile();
      final adminProfile = await _userProfileService.getAdminProfile();

      if (userProfile != null && context.mounted) {
        logger.logInfo('👤 Showing profile for user: ${userProfile['email']}');
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
              child: ProfileDialog(currentUser: userProfile),
            ),
          ),
        );
      } else if (adminProfile != null && context.mounted) {
        logger.logInfo('👤 Showing profile for admin: ${adminProfile['email']}');
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
              child: ProfileDialog(currentUser: adminProfile),
            ),
          ),
        );
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
}

  /// Function to show the create event dialog
  void showCreateEventDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CreateEventDialog(),
    );
  }

  /// Function to show the edit event dialog
  void showEditEventDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => EditEventDialog(),
    );
  }

  /// Build the card widget
  Widget buildCard({
    required String title,
    required VoidCallback onTap,
    required Color color,
    bool isDisabled = false,
  })   {
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
            color: color,
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

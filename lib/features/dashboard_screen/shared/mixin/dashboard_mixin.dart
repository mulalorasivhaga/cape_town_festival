import 'package:ct_festival/features/analytics_screen/views/rsvp_analytics_view.dart';
import 'package:ct_festival/features/auth_screens/view/login_view.dart';
import 'package:ct_festival/features/dashboard_screen/admin/view/dialogs/archive_event_dialog.dart';
import 'package:ct_festival/features/dashboard_screen/admin/view/dialogs/create_event_dialog.dart';
import 'package:ct_festival/features/dashboard_screen/admin/view/dialogs/edit_event_dialog.dart';
import 'package:ct_festival/features/dashboard_screen/shared/widgets/profile_dialog.dart';
import 'package:ct_festival/features/dashboard_screen/user/controller/user_profile_service.dart';
import 'package:ct_festival/features/dashboard_screen/user/view/dialogs/make_rsvp_dialog.dart';
import 'package:ct_festival/features/dashboard_screen/user/view/dialogs/view_user_rsvp.dart';
import 'package:ct_festival/features/dashboard_screen/user/view/dialogs/edit_rsvp_dialog.dart';
import 'package:ct_festival/features/dashboard_screen/user/view/dialogs/rate_event_dialog.dart';
import 'package:ct_festival/features/events_screen/view/events_screen.dart';
import 'package:flutter/material.dart';
import 'package:ct_festival/utils/logger.dart';
import 'dart:math' as math;
import '../../../analytics_screen/views/analytics_centre.dart';
import '../../../analytics_screen/views/user_analytics_view.dart';

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

  /// Function to show RSVP dialog
  void showRsvpDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const RsvpDialog(),
    );
  }

  /// Function to show View RSVP Dialog
  void showViewRsvpDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const ViewRsvpDialog(),
    );
  }

  /// Function to show Edit RSVP Dialog
  void showEditRsvpDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const EditRsvpDialog(),
    );
  }

  void showRsvpAnalyticsView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  RsvpAnalyticsView()),
    );
  }

  /// Function to go to Analytics Centre
  void showAnalyticsCentre(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AnalyticsCentre()),
    );
  }

  /// Function to show events view
void showEventsScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const EventsScreen()),
  );
}
  /// Function to show the rate event dialog
  void showRateEventDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const RateEventDialog(),
    );
  }

  ///Function to show User Analytics Screen
  void showUserAnalyticsView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserAnalyticsView()),
    );
  }

  /// Function to show the archive event dialog
  void showArchiveEventDialog(BuildContext context, String eventId, String eventTitle) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ArchiveEventDialog(
        eventId: eventId,
        eventTitle: eventTitle,
      ),
    );
  }
  /// Build the card shared_widget
  Widget buildCard({
    required String title,
    required VoidCallback onTap,
    required Color color,
    bool isDisabled = false,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isDesktop = screenWidth > 768;

        // Calculate dynamic sizes
        final cardSize = isDesktop
            ? math.min(constraints.maxWidth, constraints.maxHeight)
            : math.min(screenWidth / 2, constraints.maxHeight);

        // Fixed font size ratios for consistency
        final fontSize = isDesktop ? 32.0 : 24.0;
        final padding = cardSize * 0.03;

        return SizedBox(
          width: cardSize,
          height: cardSize,
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: InkWell(
              onTap: isDisabled ? null : onTap,
              borderRadius: BorderRadius.circular(15.0),
              child: Container(
                padding: EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: color,
                ),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:ct_festival/features/dashboard_screen/shared/mixin/dashboard_mixin.dart';
import 'package:ct_festival/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ct_festival/providers/auth_provider.dart';
import 'package:ct_festival/config/routes.dart';


class LogoutNavBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  LogoutNavBar({super.key});
  final AppLogger logger = AppLogger();

  @override
  LogoutNavBarState createState() => LogoutNavBarState();

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class LogoutNavBarState extends ConsumerState<LogoutNavBar> with DashboardMixin {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF474747),
      title: const Text(''),
      actions: [
        Tooltip(
          message: 'My Profile',
          child: IconButton(
            icon: const Icon(Icons.person, color: Color(0xFFAD343E)),
            onPressed: () => showProfileDialog(context),
          ),
        ),
      ],
      leading: Tooltip(
        message: 'Logout',
        child: IconButton(
          icon: const Icon(Icons.lock_outline, color: Color(0xFFAD343E)),
          onPressed: () {
            // Capture contexts before async operation
            final currentContext = context;
            final scaffoldMessenger = ScaffoldMessenger.of(currentContext);
            final navigator = Navigator.of(currentContext);

            _handleLogout(
              currentContext: currentContext,
              scaffoldMessenger: scaffoldMessenger,
              navigator: navigator,
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleLogout({
    required BuildContext currentContext,
    required ScaffoldMessengerState scaffoldMessenger,
    required NavigatorState navigator,
  }) async {
    final shouldLogout = await showDialog<bool>(
      context: currentContext,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF474747),
        title: const Text(
          'Confirm Logout',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFFAD343E)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Logout',
              style: TextStyle(color: Color(0xFFAD343E)),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      try {
        await ref.read(authProvider.notifier).signOut();
        widget.logger.logDebug('User signed out');
        navigator.pushNamedAndRemoveUntil(Routes.login, (route) => false);
      } catch (error) {
        widget.logger.logError('Error signing out: $error');
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error signing out: $error')),
        );
      }
    }
  }
}
import 'package:ct_festival/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ct_festival/providers/auth_provider.dart';

class LogoutNavBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const LogoutNavBar({super.key});

  @override
  LogoutNavBarState createState() => LogoutNavBarState();

  @override
  Size get preferredSize => Size.fromHeight(50);
}

class LogoutNavBarState extends ConsumerState<LogoutNavBar> {
  final AppLogger logger = AppLogger();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF474747),
      title: Text(''),

      actions: [
        Tooltip(
          message: 'Events',
          child: IconButton(
            icon: Icon(Icons.event_available, color: Color(0xFFAD343E)),
            onPressed: () {
              Navigator.pushNamed(context, '/events');
              logger.logDebug('Navigating to event screen');
            },
          ),
        ),
        Tooltip(
          message: 'Home',
          child: IconButton(
            icon: Icon(Icons.home, color: Color(0xFFAD343E)),
            onPressed: () {
              Navigator.pop(context);
              logger.logDebug('Navigating to home');
            },
          ),
        ),
        Tooltip(
          message: 'Logout',
          child: IconButton(
            icon: Icon(Icons.logout, color: Color(0xFFAD343E)),
            onPressed: () async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              try {
                await ref.read(authProvider.notifier).signOut();
                logger.logDebug('User signed out');
                if (mounted) {
                  navigator.pushNamedAndRemoveUntil('/MainNav', (route) => false);
                }
              } catch (error) {
                logger.logError('Error signing out: $error');
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text('Error signing out: $error')),
                );
              }
            },
          ),
        ), //logout button
      ],
    );
  }
}
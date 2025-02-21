import 'package:ct_festival/features/dashboard_screen/shared/mixin/dashboard_mixin.dart';
import 'package:ct_festival/features/dashboard_screen/shared/widgets/logout_nav.dart';
import 'package:flutter/material.dart';

class UserDashboard extends StatelessWidget with DashboardMixin {
  UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: LogoutNavBar(),
      ),
      backgroundColor: const Color(0xFF474747),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
        child: Center(
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 24.0,
              mainAxisSpacing: 24.0,
              childAspectRatio: 1.5,
              mainAxisExtent: 300,
            ),
            children: [
              buildCard(
                title: 'View\nProfile',
                onTap: () => showProfileDialog(context),
                color: const Color(0xFFAD343E),
              ),
              buildCard(
                title: 'Make\nRSVP',
                onTap: () => showRsvpDialog(context),
                color: const Color(0xFFAD343E),
              ),
              buildCard(
                title: 'View\nRSVP',
                onTap: () => showViewRsvpDialog(context),
                color: const Color(0xFFAD343E),
              ),
              buildCard(
                title: 'Edit RSVP',
                onTap: () => showEditRsvpDialog(context),
                color: const Color(0xFFAD343E),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
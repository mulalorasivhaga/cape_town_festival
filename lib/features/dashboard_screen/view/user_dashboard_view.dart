// users can see their profile details
// users can RSVP to events
// users can see their event RSVPs
// users can change their RSVP until event datetime

import 'package:ct_festival/features/home_screen/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:ct_festival/features/dashboard_screen/view/widget/logout_nav.dart';
import 'package:ct_festival/features/dashboard_screen/view/mixin/dashboard_mixin.dart';


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
                title: 'RSVP\nto Event',
                onTap: () => showRsvpDialog(context),
                color: const Color(0xFFAD343E),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
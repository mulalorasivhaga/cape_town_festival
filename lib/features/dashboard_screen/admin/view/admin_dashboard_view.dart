// view total registered users
// view registered events
// create event
// edit event
// show event history (all events)
// view stats of events and users



import 'package:ct_festival/features/dashboard_screen/shared/mixin/dashboard_mixin.dart';
import 'package:ct_festival/features/dashboard_screen/shared/widgets/logout_nav.dart';
import 'package:flutter/material.dart';

class AdminDashboardView extends StatelessWidget with DashboardMixin {
   AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: LogoutNavBar(),
      ),
      backgroundColor: Color(0xFF474747),
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
                title: 'Admin Details',
                onTap: () => showProfileDialog(context),
                color: Color(0xFFF2AF29),
              ),
              buildCard(
                title: 'Create Event',
                onTap: () => showCreateEventDialog(context),
                color: Color(0xFFF2AF29),
              ),
              buildCard(
                title: 'Edit Event',
                onTap: () => showEditEventDialog(context),
                color: Color(0xFFF2AF29),
              ),
              buildCard(
                title: 'Analytics',
                onTap: () => showAnalyticsView(context),
                color: Color(0xFFF2AF29),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
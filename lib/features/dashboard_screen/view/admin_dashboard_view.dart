// view total registered users
// view registered events
// create event
// edit event
// show event history (all events)
// view stats of events and users

import 'package:flutter/material.dart';
import '../../../shared/navigation/view/back_button.dart';
import 'package:ct_festival/features/dashboard_screen/view/mixin/dashboard_mixin.dart';

class AdminDashboardView extends StatelessWidget with DashboardMixin {
   AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(25),
        child: BackToHomeNav(),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column( mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildCard(
              title: 'Admin Card',
              onTap: () => showProfileDialog(context),
              color: Colors.blue,
            ),
            buildCard(
              title: 'Create Event',
              onTap: () => showCreateEventDialog(context),
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
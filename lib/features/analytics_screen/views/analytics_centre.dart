import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct_festival/features/analytics_screen/views/widgets/counter/counter_card.dart';
import 'package:ct_festival/features/dashboard_screen/shared/mixin/dashboard_mixin.dart';
import 'package:flutter/material.dart';
import 'package:ct_festival/features/analytics_screen/controller/analytics_services.dart';

class AnalyticsCentre extends StatelessWidget with DashboardMixin {
  AnalyticsCentre({super.key});

  @override
  Widget build(BuildContext context) {
    final analyticsService = AnalyticsService(firestore: FirebaseFirestore.instance);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF474747),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFAD343E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '',
          style: TextStyle(color: Colors.transparent),
        ),
      ),
      backgroundColor: const Color(0xFF474747),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Counter Cards Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CounterCard(
                    title: 'Total Events',
                    fetchCount: analyticsService.getTotalEvents,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CounterCard(
                    title: 'Total Users',
                    fetchCount: analyticsService.getTotalUsers,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CounterCard(
                    title: 'Total RSVP',
                    fetchCount: analyticsService.getTotalRsvp,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Grid View Section
            Expanded(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18.0,
                  mainAxisSpacing: 18.0,
                  childAspectRatio: 1.0,
                ),
                children: [
                  buildCard(
                    title: 'RSVP Analytics',
                    onTap: () => showRsvpAnalyticsView(context),
                    color: const Color(0xFFF2AF29),
                  ),
                  buildCard(
                    title: 'User Analytics',
                    onTap: () => showUserAnalyticsView(context),
                    color: const Color(0xFFF2AF29),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
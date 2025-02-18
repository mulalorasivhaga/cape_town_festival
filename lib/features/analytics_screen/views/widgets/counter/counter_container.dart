import 'package:flutter/material.dart';
import 'package:ct_festival/features/analytics_screen/controller/analytics_services.dart';
import 'package:ct_festival/features/analytics_screen/views/widgets/counter/counter_card.dart';

class CounterContainer extends StatelessWidget {
  final AnalyticsService analyticsService;

  const CounterContainer({super.key, required this.analyticsService});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CounterCard(
                  title: 'Total Users',
                  fetchCount: analyticsService.getTotalUsers,
                ),
                const SizedBox(width: 8),
                CounterCard(
                  title: 'Total Events',
                  fetchCount: analyticsService.getTotalEvents,
                ),
                const SizedBox(width: 8),
                CounterCard(
                  title: 'Total RSVPs',
                  fetchCount: analyticsService.getTotalRsvp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
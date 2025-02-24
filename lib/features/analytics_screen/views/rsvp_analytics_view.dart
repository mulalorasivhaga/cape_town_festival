import 'package:flutter/material.dart';
import 'package:ct_festival/features/analytics_screen/views/widgets/table/rsvp_details_table.dart';

class RsvpAnalyticsView extends StatelessWidget {
  const RsvpAnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RSVP Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: RsvpDetailsTable(),
      ),
    );
  }
}

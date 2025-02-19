import 'package:flutter/material.dart';
import 'package:ct_festival/features/analytics_screen/controller/analytics_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct_festival/features/analytics_screen/views/widgets/counter/counter_container.dart';
import 'package:ct_festival/features/analytics_screen/views/widgets/pie_graph/chart_container.dart';

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final analyticsService = AnalyticsService(firestore: FirebaseFirestore.instance);

    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: analyticsService.getRsvpData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFAD343E),));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: CounterContainer(analyticsService: analyticsService),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35, // Ensures the chart does not take full space,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical:10, horizontal: 16),
                    child: ChartContainer(data: snapshot.data!),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

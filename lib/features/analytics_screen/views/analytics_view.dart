import 'package:flutter/material.dart';
import 'package:ct_festival/features/analytics_screen/views/widgets/pie_graph/pie_chart_widget.dart';
import 'package:ct_festival/features/analytics_screen/views/widgets/table/leaderboard_table.dart';
import 'package:ct_festival/features/analytics_screen/controller/analytics_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct_festival/features/analytics_screen/views/widgets/counter/counter_container.dart';

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
            return const Center(child: CircularProgressIndicator(color: Color(0xFFAD343E)));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CounterContainer(analyticsService: analyticsService),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            ///RSVP distribution Pie Chart
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: PieChartWidget(dataFuture: analyticsService.getRsvpData()),
                          ),
                        ),
                        const SizedBox(width: 10), // Add some spacing between the charts
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            ///Category Pie Chart
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: PieChartWidget(dataFuture: analyticsService.getRsvpCategoryData()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    /// Table of top events
                    LeaderboardTable(data: snapshot.data!), // No Expanded here
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
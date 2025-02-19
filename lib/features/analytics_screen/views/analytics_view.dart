// analytics_view.dart
import 'package:ct_festival/features/analytics_screen/views/widgets/counter/counter_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct_festival/features/analytics_screen/views/widgets/pie_graph/pie_chart_widget.dart';
import 'package:ct_festival/features/analytics_screen/views/widgets/table/leaderboard_table.dart';
import 'package:ct_festival/features/analytics_screen/controller/analytics_services.dart';

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final analyticsService = AnalyticsService(firestore: FirebaseFirestore.instance);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: FutureBuilder<List<List<Map<String, dynamic>>>>(
        future: Future.wait([
          analyticsService.getRsvpData(),
          analyticsService.getRsvpCategoryData(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFAD343E)));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final rsvpData = snapshot.data![0];
            final categoryData = snapshot.data![1];

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Counter Cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CounterCard(
                          title: 'Total Events',
                          fetchCount: analyticsService.getTotalEvents,
                        ),
                        CounterCard(
                          title: 'Total Users',
                          fetchCount: analyticsService.getTotalUsers,
                        ),
                        CounterCard(
                          title: 'Total RSVP',
                          fetchCount: analyticsService.getTotalRsvp,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    /// TODO: Age/User Bar Graph/// Gender Pie Graph

                    /// Leaderboard Table
                    LeaderboardTable(data: rsvpData),
                    const SizedBox(height: 20),
                    ///  RSVP & Category Charts Row
                    SizedBox(
                      height: screenHeight * 0.6, // Increased height
                      child: Row(
                        children: [
                          Expanded(
                            child: PieChartWidget(
                              data: rsvpData,
                              title: 'RSVP Distribution',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: PieChartWidget(
                              data: categoryData,
                              title: 'Category Distribution',
                            ),
                          ),
                        ],
                      ),
                    ),
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
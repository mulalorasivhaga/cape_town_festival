// analytics_view.dart
import 'package:ct_festival/features/analytics_screen/views/widgets/counter/counter_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct_festival/features/analytics_screen/views/widgets/pie_graph/pie_chart_widget.dart';
import 'package:ct_festival/features/analytics_screen/views/widgets/table/leaderboard_table.dart';
import 'package:ct_festival/features/analytics_screen/controller/analytics_services.dart';
import 'package:ct_festival/features/analytics_screen/views/widgets/bar_graph/bar_graph_widget.dart';
import 'dart:math' as math;

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final analyticsService = AnalyticsService(firestore: FirebaseFirestore.instance);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFF474747),
      appBar: AppBar(
        backgroundColor: Color(0xFF474747),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFAD343E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '',
          style: TextStyle(color: Colors.transparent),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          analyticsService.getRsvpData(),
          analyticsService.getRsvpCategoryData(),
          analyticsService.getTotalGenderCount(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFAD343E)));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final rsvpData = (snapshot.data![0] as List<dynamic>).cast<Map<String, dynamic>>();
            final categoryData = (snapshot.data![1] as List<dynamic>).cast<Map<String, dynamic>>();
            final genderData = (snapshot.data![2] as List<dynamic>).cast<Map<String, dynamic>>();
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Counter Cards
                    Row(
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
                    /// Gender Distribution and Age Bar Graph Row
                    SizedBox(
                      height: screenHeight * 0.4,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3, // 30% of the width
                            child: PieChartWidget(
                              data: genderData,
                              title: 'Gender Distribution',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 7, // 70% of the width
                            child: FutureBuilder<List<Map<String, dynamic>>>(
                              future: analyticsService.getAgePerUser(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  double maxY = snapshot.data!.fold(0.0, (max, item) => 
                                    math.max(max, (item['value'] as int).toDouble()));
                                  
                                  return BarGraphWidget(
                                    data: snapshot.data!,
                                    title: 'Age Distribution',
                                    maxY: maxY + (maxY * 0.1),
                                    barColor: Colors.blue,
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFAD343E),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    /// Leaderboard Table
                    LeaderboardTable(data: rsvpData),
                    const SizedBox(height: 20),
                    ///  RSVP & Category Charts Row
                    SizedBox(
                      height: screenHeight * 0.6,
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              child: PieChartWidget(
                                data: rsvpData.isNotEmpty 
                                    ? rsvpData 
                                    : [{'label': 'No Data', 'value': 1}],
                                title: 'RSVP Distribution per Event',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Card(
                              child: PieChartWidget(
                                data: categoryData.isNotEmpty 
                                    ? categoryData 
                                    : [{'label': 'No Data', 'value': 1}],
                                title: 'RSVP Distribution per Category',
                              ),
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
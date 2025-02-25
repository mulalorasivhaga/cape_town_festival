import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct_festival/features/analytics_screen/views/widgets/pie_graph/pie_chart_widget.dart';
import 'package:ct_festival/features/analytics_screen/controller/analytics_services.dart';
import 'package:ct_festival/features/analytics_screen/views/widgets/bar_graph/bar_graph_widget.dart';
import 'dart:math' as math;

class UserAnalyticsView extends StatelessWidget {
  const UserAnalyticsView({super.key});

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
            final genderData = (snapshot.data![2] as List<dynamic>).cast<Map<String, dynamic>>();
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
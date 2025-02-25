import 'package:ct_festival/features/analytics_screen/views/widgets/table/leaderboard_table.dart';
import 'package:flutter/material.dart';
import 'package:ct_festival/features/analytics_screen/views/widgets/table/rsvp_details_table.dart';
import 'package:ct_festival/features/analytics_screen/controller/analytics_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct_festival/features/analytics_screen/views/widgets/pie_graph/pie_chart_widget.dart';


class RsvpAnalyticsView extends StatelessWidget {
  const RsvpAnalyticsView({super.key});

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
        title: const Text(
          'RSVP Analytics',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
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
            final rsvpData = (snapshot.data![0] as List<dynamic>).cast<Map<String, dynamic>>();
            final categoryData = (snapshot.data![1] as List<dynamic>).cast<Map<String, dynamic>>();


            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// Event Leaderboard Table
                    LeaderboardTable(data: rsvpData),
                    const SizedBox(height: 16),
                    /// Pie Charts
                    SizedBox(
                      height: screenHeight * 0.6, // Adjust height as needed
                      child: Row(  // Add Row here
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
                    const SizedBox(height: 16),
                    /// RSVP Details Table
                    SizedBox(
                      height: screenHeight * 0.7,  // Adjust height as needed
                      child: RsvpDetailsTable(),
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

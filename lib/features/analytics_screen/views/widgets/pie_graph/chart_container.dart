import 'package:ct_festival/features/analytics_screen/views/widgets/pie_graph/pie_chart_widget.dart';
import 'package:flutter/material.dart';

class ChartContainer extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const ChartContainer({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenHeight * 0.25, // 25% of the screen height
      width: screenWidth * 0.75, // 75% of screen width to prevent full-screen stretch
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevents unnecessary expansion
        children: [
          const Text(
            'Total RSVP per event',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: screenHeight * 0.25, // Ensures the chart does not take full space
            child: PieChartWidget(data: data),
          ),
        ],
      ),
    );
  }
}

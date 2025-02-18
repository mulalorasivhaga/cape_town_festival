import 'package:flutter/material.dart';
import 'pie_chart_widget.dart';

class ChartContainer extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const ChartContainer({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0), // Reduced padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(),
            spreadRadius: 1, // Reduced spread
            blurRadius: 3, // Reduced blur
          ),
        ],
      ),
      child: SizedBox(
        child: PieChartWidget(data: data),
      ),
    );
  }
}

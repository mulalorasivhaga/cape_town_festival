import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> dataFuture;

  const PieChartWidget({required this.dataFuture, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final data = snapshot.data!;
          final dataMap = <String, double>{};
          final colorList = [
            Colors.blue,
            Colors.red,
            Colors.green,
            Colors.orange,
            Colors.purple,
            Colors.yellow,
            Colors.pink,
            Colors.brown,
            Colors.indigo,
          ];

          for (var item in data) {
            final eventTitle = item['eventTitle'] as String?;
            final rsvpCount = item['rsvpCount'] as int?;
            if (eventTitle != null && rsvpCount != null) {
              dataMap[eventTitle] = rsvpCount.toDouble();
            }
          }

          List<PieChartSectionData> sections = dataMap.entries.map((entry) {
            final index = dataMap.keys.toList().indexOf(entry.key);
            final isTouched = index == 0; // Example logic for touched index
            final double fontSize = isTouched ? 25 : 16;
            final double radius = isTouched ? 60 : 50;

            return PieChartSectionData(
              color: colorList[index % colorList.length],
              value: entry.value,
              title: entry.value.toStringAsFixed(0), // Show RSVP count
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff),
              ),
            );
          }).toList();

          return PieChart(
            PieChartData(
              sections: sections,
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  // Handle touch interactions
                },
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              startDegreeOffset: 0,
              borderData: FlBorderData(show: false),
            ),
          );
        }
      },
    );
  }
}
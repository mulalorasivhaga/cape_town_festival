// pie_chart_widget.dart - Key changes only
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ct_festival/features/analytics_screen/views/widgets/pie_graph/chart_colours.dart';

class PieChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String title;

  const PieChartWidget({required this.data, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    final dataMap = <String, double>{};
    for (var item in data) {
      final label = item['eventTitle'] as String? ?? item['eventCategory'] as String?;
      final rsvpCount = item['rsvpCount'] as int?;

      if (label != null && rsvpCount != null) {
        dataMap[label] = (dataMap[label] ?? 0) + rsvpCount.toDouble();
      }
    }

    if (dataMap.isEmpty) {
      return const Center(child: Text('No data to display'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 600;

        List<PieChartSectionData> sections = dataMap.entries.map((entry) {
          final index = dataMap.keys.toList().indexOf(entry.key);
          final color = ChartColors.getPartyColor(index);
          return PieChartSectionData(
            color: color,
            value: entry.value,
            title: entry.value.toStringAsFixed(0),
            radius: isWideScreen ? 50 : 40,
            titleStyle: TextStyle(
              fontSize: isWideScreen ? 12 : 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList();

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isWideScreen ? 16 : 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    sectionsSpace: 2,
                    centerSpaceRadius: isWideScreen ? 40 : 30,
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: dataMap.entries.map((entry) {
                      final index = dataMap.keys.toList().indexOf(entry.key);
                      final color = ChartColors.getPartyColor(index);
                      return Container(
                        constraints: BoxConstraints(
                          maxWidth: isWideScreen
                              ? constraints.maxWidth * 0.45
                              : constraints.maxWidth * 0.95,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              color: color,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${entry.key}: ${entry.value.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: isWideScreen ? 12 : 10,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
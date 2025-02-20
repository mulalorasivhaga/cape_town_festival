// pie_chart_widget.dart - Key changes only
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ct_festival/features/analytics_screen/views/widgets/pie_graph/chart_colours.dart';

class PieChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final String title;

  const PieChartWidget({required this.data, required this.title, super.key});

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    final dataMap = <String, double>{};
    for (var item in widget.data) {
      final label = item['label'] as String?;
      final value = item['value'] as int?;
      if (label != null && value != null) {
        dataMap[label] = (dataMap[label] ?? 0) + value.toDouble();
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
          final isTouched = index == touchedIndex;
          final fontSize = isTouched ? 20.0 : 16.0;
          final radius = isTouched ? (isWideScreen ? 60.0 : 50.0) : (isWideScreen ? 50.0 : 40.0);
          
          return PieChartSectionData(
            color: color,
            value: entry.value,
            title: '${entry.key}\n${entry.value.toInt()}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            showTitle: isTouched,
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
                  widget.title,
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
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                        });
                      },
                      mouseCursorResolver: (event, response) =>
                          response != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
                    ),
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
                                '${entry.key}: ${entry.value.toInt()}',
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
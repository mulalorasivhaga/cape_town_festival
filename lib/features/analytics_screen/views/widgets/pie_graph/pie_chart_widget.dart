import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  const PieChartWidget({super.key, required this.data});

  @override
  PieChartWidgetState createState() => PieChartWidgetState();
}

class PieChartWidgetState extends State<PieChartWidget> {
  int? _touchedIndex;

  /// Generates a unique color for each pie chart section
  final List<Color> _colors = [
    Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple,
    Colors.teal, Colors.amber, Colors.pink, Colors.indigo, Colors.cyan
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              sections: _buildPieChartSections(),
              centerSpaceRadius: 40, // Space in the middle
              sectionsSpace: 2, // Small space between slices
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                      _touchedIndex = null;
                      return;
                    }
                    _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
            ),
          ),
        ),
        if (_touchedIndex != null) ...[
          const SizedBox(height: 10),
          Text(
            "Event: ${widget.data[_touchedIndex!]['eventTitle']}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            "RSVP Count: ${widget.data[_touchedIndex!]['rsvpCount']}",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ],
    );
  }

  /// Creates dynamic pie chart sections with unique colors
  List<PieChartSectionData> _buildPieChartSections() {
    return widget.data.asMap().entries.map((entry) {
      final int index = entry.key;
      final Map<String, dynamic> item = entry.value;
      final String title = item['eventTitle'];
      final int value = item['rsvpCount'];

      final bool isTouched = index == _touchedIndex;

      return PieChartSectionData(
        value: value.toDouble(),
        title: isTouched ? title : '', // Show title only if selected
        radius: isTouched ? 75 : 60, // Animate section expansion
        titleStyle: TextStyle(
          fontSize: isTouched ? 16 : 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: _colors[index % _colors.length], // Assign unique color
      );
    }).toList();
  }
}

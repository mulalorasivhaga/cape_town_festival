import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const PieChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {};
    List<Color> colorList =
    [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.yellow,
      Colors.pink,
      Colors.brown,
      Colors.teal,
      Colors.indigo,
    ];

    for (var item in data) {
      dataMap[item['eventTitle']] = item['rsvpCount'].toDouble();
    }

    return PieChart(
      dataMap: dataMap,
      baseChartColor: Colors.grey[50]!.withValues(),
      colorList: colorList,
      chartValuesOptions: ChartValuesOptions(
        //showChartValuesInPercentage: true,
      ),
      totalValue: 10,
    );
  }
}

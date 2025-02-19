// lib/results/utils/election_chart_colors.dart

import 'package:flutter/material.dart';


class ChartColors {
  // General colors
  static const Color primary =  Color(0xFFCCA43B);
  static const Color secondary = Color(0xFF242F40);

  // Text colors
  static const Color textPrimary = Color(0xFFCCA43B);
  static const Color textSecondary = Color(0xFF242F40);

  // Card colors
  static const Color cardBackground = Color(0xFF242F40);
  static const Color cardHeaderBackground = Color(0xFFF5F5F5);
  static const Color cardBorder = Color(0xFFEEEEEE);

  // Party colors
  static List<Color> partyColors = [
    Colors.blueAccent,
    Colors.red,
    Colors.blueGrey,
    Colors.yellow[700]!,
    Colors.green,
    Colors.deepOrangeAccent,
    Colors.purple,
    Colors.teal,
    Colors.brown,
    Colors.indigo,
    Colors.cyan,
    Colors.amber,
    Colors.deepPurpleAccent,
    Colors.pinkAccent,
    Colors.lime[800]!,
    Colors.orange,
    Colors.lightBlue,
    Colors.grey,
    Colors.lightGreen,
    Colors.black54,
  ];


  // Get party color by index
  static Color getPartyColor(int index) {
    return partyColors[index % partyColors.length];
  }
}
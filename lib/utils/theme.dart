import 'package:flutter/material.dart';

// Color(0xFFE0E0CE)  // Light Yellowish
// Color(0xFF000000)  // Black
// Color(0xFFF2AF29)  // Bright Orange
// Color(0xFF474747)  // Dark Gray
// Color(0xFFAD343E)  // Dark Red


class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Colors.green,
      scaffoldBackgroundColor: Colors.green,
      appBarTheme: AppBarTheme(
        color: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
        bodyMedium: TextStyle(color: Colors.black87, fontSize: 14),
        titleLarge: TextStyle(color: Colors.red, fontSize: 22, fontWeight: FontWeight.bold),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.green,
        textTheme: ButtonTextTheme.primary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.yellow, // Yellow FAB
        foregroundColor: Colors.black,
      ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.yellow),
    );
  }
}
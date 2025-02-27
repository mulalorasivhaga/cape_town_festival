import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WeatherInfoWidget extends StatelessWidget {
  final String weatherInfo;
  final String weatherCondition; // New parameter for weather condition

  const WeatherInfoWidget({
    super.key,
    required this.weatherInfo,
    required this.weatherCondition, // Accept weather condition
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Determine the icon based on the weather condition
    IconData weatherIcon = FontAwesomeIcons.cloud; // Default icon
    switch (weatherCondition.toLowerCase()) {
      case 'clear':
        weatherIcon = FontAwesomeIcons.sun;
        break;
      case 'clouds':
        weatherIcon = FontAwesomeIcons.cloud;
        break;
      case 'rain':
        weatherIcon = FontAwesomeIcons.cloudRain;
        break;
      case 'snow':
        weatherIcon = FontAwesomeIcons.snowflake;
        break;
      case 'thunderstorm':
        weatherIcon = FontAwesomeIcons.bolt;
        break;
      default:
        weatherIcon = FontAwesomeIcons.cloudSun; // Fallback icon
    }

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.03), // Responsive padding
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF2AF29), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(weatherIcon, color: Colors.orange, size: 24), // Use the determined icon
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              weatherInfo,
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth * 0.02, // Responsive font size
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
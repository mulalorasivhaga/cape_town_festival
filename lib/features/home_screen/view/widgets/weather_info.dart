import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class WeatherInfoWidget extends StatelessWidget {
  final String weatherInfo;
  final String weatherCondition;
  final String location;
  final int humidity;
  final double windSpeed;
  final DateTime lastUpdated;

  const WeatherInfoWidget({
    super.key,
    required this.weatherInfo,
    required this.weatherCondition,
    required this.location,
    required this.humidity,
    required this.windSpeed,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('HH:mm').format(lastUpdated);

    IconData weatherIcon = FontAwesomeIcons.cloud;
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
        weatherIcon = FontAwesomeIcons.cloudSun;
    }

    return Container(
      height: 300, // Match map height
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF474747),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            location,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(weatherIcon, color: const Color(0xFFF2AF29), size: 32),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  weatherInfo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(FontAwesomeIcons.droplet, size: 16, color: Color(0xFFF2AF29)),
              const SizedBox(width: 8),
              Text(
                'Humidity: $humidity%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(FontAwesomeIcons.wind, size: 16, color: Color(0xFFF2AF29)),
              const SizedBox(width: 8),
              Text(
                'Wind: ${windSpeed.toStringAsFixed(1)} m/s',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Last Updated: $formattedTime',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
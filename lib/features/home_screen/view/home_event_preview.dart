import 'package:ct_festival/features/home_screen/controller/weather_service.dart';
import 'package:ct_festival/features/home_screen/view/widgets/comment_table.dart';
import 'package:ct_festival/features/home_screen/view/widgets/weather_info.dart';
import 'package:flutter/material.dart';
import 'package:ct_festival/features/events_screen/model/event_model.dart';
import 'package:ct_festival/utils/logger.dart';
import 'package:ct_festival/features/home_screen/view/widgets/map_widget.dart';
import 'package:ct_festival/features/home_screen/view/widgets/event_header.dart';
import 'package:ct_festival/features/home_screen/view/widgets/event_details.dart';

class HomeEventPreview extends StatefulWidget {
  final Event event;
  final bool showMap;

  const HomeEventPreview({
    super.key,
    required this.event,
    this.showMap = false,
  });

  @override
  State<HomeEventPreview> createState() => _HomeEventPreviewState();
}

class _HomeEventPreviewState extends State<HomeEventPreview> {
  final AppLogger logger = AppLogger();
  String weatherInfo = '';
  String weatherCondition = '';
  int humidity = 0;
  double windSpeed = 0.0;
  final WeatherService weatherService = WeatherService();
  final double _padding = 50.0;
  DateTime lastUpdated = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  /// Fetch weather data from the API
  Future<void> fetchWeather() async {
    try {
      String locationToUse = widget.event.location;

      if (locationToUse.isEmpty) {
        locationToUse = "Cape Town";
      }

      final weatherData = await weatherService.getCurrentWeather(locationToUse);

      if (weatherData['main'] == null) {
        // Try again with Cape Town if the original location failed
        if (locationToUse != "Cape Town") {
          locationToUse = "Cape Town";
          final fallbackData = await weatherService.getCurrentWeather(locationToUse);
          if (fallbackData['main'] != null) {
            updateWeatherState(fallbackData, locationToUse);
            return;
          }
        }
        setState(() {
          weatherInfo = 'Weather data unavailable';
          weatherCondition = '';
          humidity = 0;
          windSpeed = 0.0;
          lastUpdated = DateTime.now();
        });
        return;
      }

      updateWeatherState(weatherData, locationToUse);

    } catch (e) {
      logger.logError('Failed to fetch weather data', e);
      // Try Cape Town as fallback
      try {
        final fallbackData = await weatherService.getCurrentWeather("Cape Town");
        updateWeatherState(fallbackData, "Cape Town");
      } catch (e) {
        setState(() {
          weatherInfo = 'Weather data unavailable';
          weatherCondition = '';
          humidity = 0;
          windSpeed = 0.0;
          lastUpdated = DateTime.now();
        });
      }
    }
  }

  void updateWeatherState(Map<String, dynamic> weatherData, String location) {
    setState(() {
      weatherInfo = 'Temperature: ${weatherData['main']['temp']}°C\n'
          'Weather: ${weatherData['weather'][0]['description']}';
      weatherCondition = weatherData['weather'][0]['main'];
      humidity = weatherData['main']['humidity'] as int;
      windSpeed = (weatherData['wind']['speed'] as num).toDouble();
      lastUpdated = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    //final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFAD343E),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: _padding),
          child: Column(
            children: [
              /// EventHeader widget
              EventHeader(event: widget.event), // Use EventHeader
              const SizedBox(height: 20),
              /// EventDetails widget
              EventDetails(event: widget.event), // Use EventDetails
              if (widget.showMap) ...[
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 2,
                      child: MapWidget(
                        eventTitle: widget.event.title,
                        location: widget.event.location,
                        height: 300,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      flex: 1,
                      child: WeatherInfoWidget(
                          weatherInfo: weatherInfo,
                          weatherCondition: weatherCondition,
                          location: widget.event.location,
                          humidity: humidity,
                          windSpeed: windSpeed,
                          lastUpdated: DateTime.now()),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
              // Add Comments Section
              SizedBox(
                height: 400, // Fixed height for comments table
                child: CommentsTable(eventId: widget.event.id),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

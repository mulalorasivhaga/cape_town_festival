import 'package:ct_festival/features/home_screen/controller/weather_service.dart';
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
  final WeatherService weatherService = WeatherService();
  final double _padding = 50.0;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    try {
      final weatherData = await weatherService.getCurrentWeather(widget.event.location);
      setState(() {
        weatherInfo = 'Temperature: ${weatherData['main']['temp']}°C\n'
            'Weather: ${weatherData['weather'][0]['description']}';
        weatherCondition = weatherData['weather'][0]['main']; // Set weather condition
      });
    } catch (e) {
      setState(() {
        weatherInfo = 'Failed to load weather data';
      });
    }
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
              EventHeader(event: widget.event), // Use EventHeader
              const SizedBox(height: 20),
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
                      child: WeatherInfoWidget(weatherInfo: weatherInfo, weatherCondition: weatherCondition),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
              //CommentSection(eventId: widget.event.id), // pass event ID
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

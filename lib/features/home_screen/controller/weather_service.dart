import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ct_festival/config/api_keys.dart';


class WeatherService {
  final String apiKey = WeatherApiKeys.openWeather;

  Future<Map<String, dynamic>> getCurrentWeather(String city) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
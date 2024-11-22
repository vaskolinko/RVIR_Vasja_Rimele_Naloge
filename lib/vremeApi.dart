import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'e2077e5f710fbe56786acebcfbbdc9ba';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Pridobivanje trenutnega vremena
  Future<Map<String, dynamic>> fetchWeather(String cityName) async {
    final String url =
        '$baseUrl/weather?q=$cityName&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Pridobivanje tedenske napovedi
  Future<Map<String, dynamic>> fetchWeeklyWeather(String cityName) async {
    final String url =
        '$baseUrl/forecast?q=$cityName&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weekly weather data');
    }
  }
}

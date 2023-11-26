import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/models/weather_forecast.dart';

class WeatherService {
  // ignore: constant_identifier_names
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5';
  final String apiKey = dotenv.get('OPENWEATHER_API');

  WeatherService();

  Future<WeatherForecast> getWeatherForecast({
    required num lat,
    required num long,
  }) async {
    final response = await http.get(
      Uri.parse(
          '$BASE_URL/forecast?lat=$lat&lon=$long&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      return WeatherForecast.fromJson(jsonDecode(response.body));
    }

    throw Exception('Error getting weathers');
  }

  Future<Weather> getCurrentWeather({
    required num lat,
    required num long,
  }) async {
    final response = await http.get(
      Uri.parse(
          '$BASE_URL/weather?lat=$lat&lon=$long&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    }

    throw Exception('Error getting weathers');
  }
}

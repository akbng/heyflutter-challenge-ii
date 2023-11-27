import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/models/weather_forecast.dart';

class WeatherService {
  // ignore: constant_identifier_names
  static const BASE_URL = 'http://api.weatherapi.com/v1';
  final String apiKey = dotenv.get('WEATHER_API_KEY');

  WeatherService();

  Future<WeatherForecast> getWeatherForecast(String locationId) async {
    final response = await http.get(
      Uri.parse(
          '$BASE_URL/forecast.json?key=$apiKey&q=$locationId&days=5&aqi=no&alerts=no'),
    );

    if (response.statusCode == 200) {
      return WeatherForecast.fromJson(jsonDecode(response.body));
    }

    throw Exception('Error getting weathers');
  }

  Future<WeatherForecast> getWeatherForecastCoords({
    required num lat,
    required num long,
  }) async {
    final response = await http.get(
      Uri.parse(
          '$BASE_URL/forecast.json?key=$apiKey&q=$lat,$long&days=5&aqi=no&alerts=no'),
    );

    if (response.statusCode == 200) {
      return WeatherForecast.fromJson(jsonDecode(response.body));
    }

    throw Exception('Error getting weathers');
  }

  Future<Weather> getCurrentWeather(String locationId) async {
    final response = await http.get(
        Uri.parse('$BASE_URL/current.json?key=$apiKey&q=$locationId&aqi=no'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    }

    throw Exception('Error getting weathers');
  }

  Future<Weather> getCurrentWeatherCoords({
    required num lat,
    required num long,
  }) async {
    final response = await http.get(
        Uri.parse('$BASE_URL/current.json?key=$apiKey&q=$lat,$long&aqi=no'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    }

    throw Exception('Error getting weathers');
  }

  // avoid this function - can cause trouble with city names
  Future<Weather> getCurrentWeatherCity(String cityName) async {
    final response = await http.get(
        Uri.parse('$BASE_URL/current.json?key=$apiKey&q=$cityName&aqi=no'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    }

    throw Exception('Error getting weathers');
  }
}

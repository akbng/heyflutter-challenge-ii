import 'package:weather_app/models/weather.dart';

class WeatherForecast {
  final Weather currentWeather;

  final List<Weather> forecasts;
  final String location;

  WeatherForecast({
    required this.forecasts,
    required this.currentWeather,
    required this.location,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      currentWeather: Weather.fromJson(json),
      forecasts: (json['forecast']['forecastday'] as List)
          .map((weather) => Weather.fromForcastJson(weather))
          .where((weather) => weather.date.isAfter(DateTime.now()))
          .toList(),
      location: json['location']['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentWeather': currentWeather.toJson(),
      'forecasts': forecasts.map((weather) => weather.toJson()).toList(),
      'location': location,
    };
  }
}

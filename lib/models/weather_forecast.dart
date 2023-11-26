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
    List<dynamic> forecastEvery3Hrs = json['list'];
    List<Weather> forecastEveryDays = forecastEvery3Hrs
        .where((weatherJson) {
          final date = DateTime.fromMillisecondsSinceEpoch(
              weatherJson['dt'].toInt() * 1000);
          final dayOfForecast = DateTime(2023, 11, 14);
          return date.isAfter(dayOfForecast) && date.toUtc().hour == 0;
        })
        .map((weatherJson) => Weather.fromJson(weatherJson))
        .toList();

    return WeatherForecast(
      forecasts: forecastEveryDays.sublist(0, 4),
      currentWeather: Weather.fromJson(forecastEvery3Hrs[0]),
      location: json['city']['name'],
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

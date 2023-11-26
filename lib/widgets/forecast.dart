import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/weather.dart';

class DailyForecastCard extends StatelessWidget {
  const DailyForecastCard({super.key, required this.forecast});

  final List<Weather> forecast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 16,
      ),
      child: Card(
        elevation: 0,
        color: const Color(0xFF535353).withOpacity(.6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final weather in forecast)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Text(
                      DateFormat('E dd').format(weather.date),
                      style: const TextStyle(color: Colors.white),
                    ),
                    Image.asset(
                      'assets/images/weather.png',
                      height: 30,
                    ),
                    Text(
                      "${weather.temperature.round()}°C",
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      "${weather.windSpeed}km/h",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}

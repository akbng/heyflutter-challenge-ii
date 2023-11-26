import 'package:flutter/material.dart';

import '../models/location.dart';
import '../models/weather.dart';
import '../screens/home_screen.dart';
import '../services/weather_services.dart';

class SavedLocationWidget extends StatefulWidget {
  final Location savedLocation;

  const SavedLocationWidget({
    super.key,
    required this.savedLocation,
  });

  @override
  State<SavedLocationWidget> createState() => _SavedLocationWidgetState();
}

class _SavedLocationWidgetState extends State<SavedLocationWidget> {
  final _weatherService = WeatherService('e71d0b53dfb243b161d181f13a8d99fd');

  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _fetchCurrentWeather();
  }

  Future<void> _fetchCurrentWeather() async {
    final latitude = widget.savedLocation.latitude;
    final longitude = widget.savedLocation.longitude;

    try {
      final currentWeather = await _weatherService.getCurrentWeather(
        lat: latitude,
        long: longitude,
      );

      if (mounted) {
        setState(() {
          _weather = currentWeather;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => HomeScreen(
              currentPos: widget.savedLocation,
            ),
          ),
        );
      },
      child: Card(
          elevation: 0,
          color: const Color(0xFFAAA5A5).withOpacity(0.5),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.savedLocation.name),
                    Text(_weather?.condition ?? ""),
                    const SizedBox(height: 20),
                    Text("Humidity ${_weather?.humidity}%"),
                    Text("Wind ${_weather?.windSpeed}km/h"),
                  ],
                ),
                Column(
                  children: [
                    Image.asset(
                      'assets/images/weather.png',
                      height: 30,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${_weather?.temperature.round()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text("°C"),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

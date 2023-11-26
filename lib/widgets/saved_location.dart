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
  final _weatherService = WeatherService();

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
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.savedLocation.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(_weather?.condition ?? "",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  )),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Text("Humidity "),
                          Text(
                            "${_weather?.humidity.round() ?? 0}%",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Wind "),
                          Text(
                            "${_weather?.windSpeed ?? 0}km/h",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          '${_weather?.temperature.round() ?? 0}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            "°C",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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

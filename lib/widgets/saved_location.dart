import 'package:flutter/material.dart';
import 'package:weather_app/services/location_services.dart';
import 'package:weather_app/widgets/helper/show_error_snackbar.dart';

import '../models/location.dart';
import '../models/weather.dart';
import '../screens/home_screen.dart';
import '../services/weather_services.dart';
import 'add_location.dart';

class SavedLocationWidget extends StatefulWidget {
  final Location savedLocation;
  final void Function() refreshLocations;

  const SavedLocationWidget({
    super.key,
    required this.savedLocation,
    required this.refreshLocations,
  });

  @override
  State<SavedLocationWidget> createState() => _SavedLocationWidgetState();
}

class _SavedLocationWidgetState extends State<SavedLocationWidget> {
  final _weatherService = WeatherService();
  bool showUpdate = false;

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
      final currentWeather = await _weatherService.getCurrentWeatherCoords(
        lat: latitude,
        long: longitude,
      );

      if (mounted) {
        setState(() {
          _weather = currentWeather;
        });
      }
    } catch (error) {
      if (context.mounted) {
        Navigator.of(context).pop();
        showErrorSnackbar(context, error.toString().substring(11));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => HomeScreen(
              currentPos: widget.savedLocation,
            ),
          ),
        );
      },
      onLongPress: () {
        setState(() {
          showUpdate = true;
        });
      },
      onLongPressCancel: () {
        setState(() {
          showUpdate = false;
        });
      },
      child: Card(
          elevation: 0,
          color: const Color(0xFFAAA5A5).withOpacity(0.5),
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _weather?.condition ?? "",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
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
                        _weather?.icon == null
                            ? Image.asset(
                                "assets/images/weather.png",
                                height: 30,
                              )
                            : Image.network(_weather!.icon!, height: 50),
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
              ),
              if (showUpdate)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () async {
                                await showModalBottomSheet(
                                  context: context,
                                  useSafeArea: true,
                                  isScrollControlled: true,
                                  builder: (ctx) => AddLocationWidget(
                                      location: widget.savedLocation),
                                );
                              },
                              icon: const Icon(Icons.update_rounded,
                                  size: 45, color: Colors.white),
                            ),
                            const Text("update")
                          ],
                        ),
                        const SizedBox(width: 24),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  showUpdate = false;
                                });
                              },
                              icon: const Icon(Icons.clear_rounded,
                                  size: 45, color: Colors.white),
                            ),
                            const Text("cancel")
                          ],
                        ),
                        const SizedBox(width: 24),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () async {
                                await LocationService()
                                    .clearLocation(widget.savedLocation);
                                widget.refreshLocations();
                              },
                              icon: const Icon(Icons.delete_rounded,
                                  size: 45, color: Colors.white),
                            ),
                            const Text("delete")
                          ],
                        ),
                      ],
                    ),
                  ),
                )
            ],
          )),
    );
  }
}

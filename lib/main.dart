import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_app/models/location.dart';
import 'package:weather_app/screens/home_screen.dart';
import 'package:weather_app/services/location_services.dart';
import 'package:weather_app/services/storage_services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Location? position;
  final _locationServices = LocationService();

  @override
  void initState() {
    _fetchCurrentPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = const Scaffold(
      body: Center(child: Text("Loading Screen")),
    );

    if (position != null) {
      body = HomeScreen(currentPos: position!);
    }

    return MaterialApp(
      // default all texts to be white color
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
        cardTheme: const CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            color: Colors.white,
          ),
          bodySmall: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: body,
    );
  }

  Future<void> _fetchCurrentPosition() async {
    try {
      final pos = await _locationServices.getCurrentPositionCoords();
      final currentPos = await _locationServices.getPlaceDetailsFromCoords(
        lat: pos.latitude,
        long: pos.longitude,
      );
      setState(() {
        position = currentPos;
      });

      await StorageServices.setString(
        key: "current_position",
        value: jsonEncode(currentPos),
      );
    } catch (error) {
      print(error);
    }
  }
}

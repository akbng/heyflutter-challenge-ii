import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/location.dart';
import 'package:weather_app/models/location_image.dart';

import 'storage_services.dart';

class LocationService {
  // ignore: constant_identifier_names
  static const BASE_URL = 'http://api.weatherapi.com/v1';
  final String apiKey = dotenv.get('WEATHER_API_KEY');

  LocationService();

  Future<void> saveLocation({
    required Location location,
    LocationImage? image,
  }) async {
    final savedLocations =
        await StorageServices.getStringList("saved_locations");

    bool locationIsSaved = savedLocations
        .map((location) => Location.fromJson(jsonDecode(location)))
        .any(
          (savedLocation) =>
              '${savedLocation.name},${savedLocation.country}'.toLowerCase() ==
              '${location.name},${location.country}'.toLowerCase(),
        );

    if (locationIsSaved) {
      throw Exception("Location already saved");
    }

    if (image != null) {
      location.setImage(image.url, image.blurHash);
    }

    savedLocations.add(jsonEncode(location));

    StorageServices.setStringList(
      key: "saved_locations",
      value: savedLocations,
    );
  }

  Future<List<LocationImage>> getLocationImages(String query) async {
    final clientId = dotenv.get('UNSPLASH_CLIENT_ID');
    const baseUrl = "https://api.unsplash.com";
    const imagerPerRequest = 20;
    final response = await http.get(Uri.parse(
        "$baseUrl/search/photos?query=$query&client_id=$clientId&per_page=$imagerPerRequest&orientation=portrait&content_filter=high"));
    if (response.statusCode == 200) {
      final images = jsonDecode(response.body);
      return (images['results'] as List)
          .map((image) => LocationImage.fromJson(image))
          .toList();
    }
    throw Exception('Error getting images for the location');
  }

  Future<Position> getCurrentPositionCoords() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return position;
  }

  Future<List<Location>> searchLocation(String query) async {
    final reponse = await http.get(
      Uri.parse("$BASE_URL/search.json?q=$query&key=$apiKey"),
    );
    if (reponse.statusCode == 200) {
      final suggestions = jsonDecode(reponse.body);
      return (suggestions as List)
          .map((suggestion) => Location.fromJson(suggestion))
          .toList();
    }

    throw Exception('Error getting location suggestions');
  }

  Future<Location> getPlaceDetailsFromCoords({
    required num lat,
    required num long,
  }) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/search.json?key=$apiKey&q=$lat,$long'),
    );

    if (response.statusCode == 200) {
      return Location.fromJson(jsonDecode(response.body).first);
    }

    throw Exception('Error getting place details');
  }
}

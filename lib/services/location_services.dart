import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/location.dart';
import 'package:weather_app/models/location_image.dart';
import 'package:weather_app/models/location_suggestion.dart';

import 'storage_services.dart';

class LocationService {
  // ignore: constant_identifier_names
  static const BASE_URL = 'http://api.openweathermap.org/geo/1.0';
  final String apiKey = dotenv.get('OPENWEATHER_API');

  LocationService();

  Future<void> saveLocation({
    required Location location,
    LocationImage? image,
  }) async {
    final savedLocations =
        await StorageServices.getStringList("saved_locations");
    final locationJson = jsonEncode(location);
    if (savedLocations.contains(locationJson)) {
      throw Exception("Location already saved");
    }

    if (image != null) {
      location.setImage(image.url, image.blurHash);
    }

    savedLocations.add(jsonEncode(location));
    print(savedLocations);
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

  Future<List<LocationSuggestion>> getLocationSuggestions(String query) async {
    const baseUrl = "https://autocomplete.travelpayouts.com/places2";
    final reponse = await http.get(
      Uri.parse("$baseUrl?term=$query&types[]=city&locale=en"),
    );
    if (reponse.statusCode == 200) {
      final suggestions = jsonDecode(reponse.body);
      return (suggestions as List)
          .map((suggestion) => LocationSuggestion.fromJson(suggestion))
          .toList();
    }

    throw Exception('Error getting location suggestions');
  }

  Future<Location> getPlaceDetails(String placeName) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/direct?q=$placeName&appid=$apiKey&limit=5'),
    );

    if (response.statusCode == 200) {
      return Location.fromJson(jsonDecode(response.body));
    }

    throw Exception('Error getting place details');
  }

  Future<Location> getPlaceDetailsFromCoords({
    required num lat,
    required num long,
  }) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/reverse?lat=$lat&lon=$long&appid=$apiKey&limit=5'),
    );

    if (response.statusCode == 200) {
      return Location.fromJson(jsonDecode(response.body));
    }

    throw Exception('Error getting place details');
  }
}
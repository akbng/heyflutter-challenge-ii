import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/models/google/location.dart';
import 'package:weather_app/models/google/location_suggestion.dart';

class GoogleLocationService {
  // ignore: constant_identifier_names
  static const BASE_URL = 'https://maps.googleapis.com/maps/api/place';
  final String apiKey;

  GoogleLocationService(this.apiKey);

  Future<List<GoogleLocationSuggestion>> getSuggestions(
      String inputText) async {
    final response = await http.get(Uri.parse(
        '$BASE_URL/autocomplete/json?input=$inputText&types=(cities)&key=$apiKey'));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      List<dynamic> predictions = body['predictions'];
      return predictions
          .map((prediction) => GoogleLocationSuggestion.fromJson(prediction))
          .toList();
    }

    throw Exception('Error getting autocomplete suggestions');
  }

  Future<GoogleLocation> getPlaceDetails(String placeId) async {
    final response = await http.get(Uri.parse(
        '$BASE_URL/details/json?place_id=$placeId&fields=photo&key=$apiKey'));

    if (response.statusCode == 200) {
      return GoogleLocation.fromJson(jsonDecode(response.body));
    }

    throw Exception('Error getting place details');
  }

  Future<Uri> getImage(String photoReference, {int maxWidth = 400}) async {
    final image = await http.get(Uri.parse(
        '$BASE_URL/photo?maxwidth=$maxWidth&photoreference=$photoReference&key=$apiKey'));

    if (image.statusCode == 200) {
      return Uri.parse(image.body);
    }

    // TODO: return a dummy image if the image is not fetched
    return Uri.parse('');
  }
}

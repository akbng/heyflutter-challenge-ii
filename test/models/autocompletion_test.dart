import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/utils/file_utils.dart';
import 'package:weather_app/models/google/location_suggestion.dart';

void main() {
  test('LocationSuggestion should parse JSON correctly', () {
    const json = {
      "place_id": "abcd123",
      "structured_formatting": {
        "main_text": "Paris",
        "secondary_text": "France"
      }
    };

    final suggestion = GoogleLocationSuggestion.fromJson(json);
    expect(suggestion.city, "Paris");
    expect(suggestion.country, "France");
    expect(suggestion.placeId, "abcd123");
  });

  test('Forecast.fromJson should parse multiple JSON correctly', () async {
    final sampleData = await readJsonFile('test/mock_data/autocomplete.json');
    List<dynamic> predictions = sampleData['predictions'];
    final suggestions = predictions
        .map((prediction) => GoogleLocationSuggestion.fromJson(prediction))
        .toList();

    expect(suggestions.first.city, "Paris");
    expect(suggestions.first.country, "France");
    expect(suggestions.first.placeId, "ChIJD7fiBh9u5kcRYJSMaMOCCwQ");
  });
}

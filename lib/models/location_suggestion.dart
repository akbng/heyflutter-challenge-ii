class LocationSuggestion {
  final String cityName;
  final String country;
  final num lat;
  final num long;

  LocationSuggestion({
    required this.cityName,
    required this.country,
    required this.lat,
    required this.long,
  });

  factory LocationSuggestion.fromJson(Map<String, dynamic> json) {
    return LocationSuggestion(
      cityName: json['name'],
      country: json['country_name'],
      lat: json['coordinates']['lat'],
      long: json['coordinates']['lon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'country_name': country,
      'coordinates': {
        'lat': lat,
        'lon': long,
      },
    };
  }
}

class GoogleLocationSuggestion {
  final String city;
  final String country;
  final String placeId;

  GoogleLocationSuggestion(
      {required this.city, required this.country, required this.placeId});

  factory GoogleLocationSuggestion.fromJson(Map<String, dynamic> json) {
    return GoogleLocationSuggestion(
        city: json["structured_formatting"]['main_text'],
        country: json["structured_formatting"]['secondary_text'],
        placeId: json['place_id']);
  }
}

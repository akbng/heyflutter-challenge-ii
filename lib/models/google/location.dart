class GoogleLocation {
  final String city;
  final String country;
  final String placeId;
  final double latitude;
  final double longitude;
  final String? photoReference;

  GoogleLocation(
      {required this.city,
      required this.country,
      required this.placeId,
      required this.latitude,
      required this.longitude,
      this.photoReference});

  factory GoogleLocation.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> result = json['result'];
    List<dynamic> photosJson = result['photos'];

    List<dynamic> addressComponents = result['address_components'];

    final city = addressComponents.firstWhere((component) {
      List<dynamic> componentTypes = component['types'];
      return componentTypes.contains('locality') ||
          componentTypes.contains("administrative_area_level_3");
    }, orElse: () => null);

    final country = addressComponents.firstWhere((component) {
      List<dynamic> componentTypes = component['types'];
      return componentTypes.contains('country');
    }, orElse: () => null);

    return GoogleLocation(
      city: city?['long_name'].toString() ?? '',
      country: country?['long_name'].toString() ?? '',
      placeId: result['place_id'].toString(),
      latitude: result['geometry']['location']['lat'],
      longitude: result['geometry']['location']['lng'],
      photoReference: photosJson.firstWhere(
          (photo) => photo['height'] > photo['width'],
          orElse: () => photosJson.firstOrNull)?['photo_reference'],
    );
  }
}

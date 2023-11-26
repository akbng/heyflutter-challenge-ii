class Location {
  final String name;
  final num latitude;
  final num longitude;
  final String country;
  final String? state;
  String? imageHash;
  String? image;

  Location({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.country,
    this.state,
    this.image,
    this.imageHash,
  });

  // setter for image and imageHash
  void setImage(String image, String? imageHash) {
    this.image = image;
    this.imageHash = imageHash;
  }

  factory Location.fromJson(dynamic json) {
    return Location(
      name: json[0]['name'],
      latitude: json[0]['lat'],
      longitude: json[0]['lon'],
      country: json[0]['country'],
      state: json[0]['state'],
      image: json[0]['image'],
      imageHash: json[0]['image_hash'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lat': latitude,
      'lon': longitude,
      'country': country,
      'state': state,
      'image': image,
      'image_hash': imageHash
    };
  }
}

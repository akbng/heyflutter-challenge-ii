class Location {
  final String id;
  final String name;
  final num latitude;
  final num longitude;
  final String country;
  final String? state;
  String? imageHash;
  String? image;

  Location({
    required this.id,
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
      id: json['id'].toString(),
      name: json['name'],
      latitude: json['lat'],
      longitude: json['lon'],
      country: json['country'],
      state: json['region'],
      image: json['image'],
      imageHash: json['image_hash'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lat': latitude,
      'lon': longitude,
      'country': country,
      'region': state,
      'image': image,
      'image_hash': imageHash
    };
  }
}

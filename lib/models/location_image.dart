class LocationImage {
  final String url;
  final String? smallUrl;
  final String? blurHash;
  final int width;
  final int height;
  final String? userName;
  final String? userLink;

  LocationImage({
    required this.url,
    required this.width,
    required this.height,
    this.blurHash,
    this.smallUrl,
    this.userName,
    this.userLink,
  });

  factory LocationImage.fromJson(Map<String, dynamic> json) {
    return LocationImage(
      url: json['urls']['regular'],
      smallUrl: json['urls']['small'],
      blurHash: json['blur_hash'],
      width: json['width'],
      height: json['height'],
      userName: json['user']['name'],
      userLink: json['user']['links']['self'],
    );
  }

  Map<String, dynamic> toJson() => {
        'urls': {
          'small': url,
          'regular': smallUrl,
        },
        'blur_hash': blurHash,
        'width': width,
        'height': height,
        'user': {
          'name': userName,
          'links': {'self': userLink},
        },
      };
}

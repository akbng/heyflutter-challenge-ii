class Weather {
  final String condition;

  final double temperature;
  final double humidity;
  final double pressure;
  final double windSpeed;
  final double realFeel;
  final double? minTemp;
  final double? maxTemp;
  final DateTime date;

  Weather({
    required this.condition,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.realFeel,
    required this.pressure,
    required this.date,
    this.minTemp,
    this.maxTemp,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      condition: json['weather'][0]['main'],
      temperature: json['main']['temp'].toDouble(),
      humidity: json['main']['humidity'].toDouble(),
      pressure: json['main']['pressure'].toDouble(),
      windSpeed: json['wind']['speed'].toDouble(),
      realFeel: json['main']['feels_like'].toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'].toInt() * 1000),
      minTemp: json['main']?['temp_min']?.toDouble(),
      maxTemp: json['main']?['temp_max']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weather': [
        {
          'main': condition,
        }
      ],
      'main': {
        'temp': temperature,
        'humidity': humidity,
        'pressure': pressure,
        'feels_like': realFeel,
      },
      'wind': {
        'speed': windSpeed,
      },
      'dt': date.millisecondsSinceEpoch ~/ 1000,
    };
  }
}

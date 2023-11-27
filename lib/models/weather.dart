class Weather {
  final String condition;
  final int conditionId;
  final double temperature;
  final double humidity;
  final double pressure;
  final double windSpeed;
  final double realFeel;
  final double? minTemp;
  final double? maxTemp;
  final String? icon;
  final DateTime date;

  Weather({
    required this.condition,
    required this.conditionId,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.realFeel,
    required this.pressure,
    required this.date,
    this.minTemp,
    this.maxTemp,
    this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final currentWeather = json['current'];
    return Weather(
      condition: currentWeather['condition']['text'],
      icon: 'https:${currentWeather['condition']['icon']}',
      conditionId: currentWeather['condition']['code'],
      temperature: currentWeather['temp_c'].toDouble(),
      humidity: currentWeather['humidity'].toDouble(),
      pressure: currentWeather['pressure_mb'].toDouble(),
      windSpeed: currentWeather['wind_kph'].toDouble(),
      realFeel: currentWeather['feelslike_c'].toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(
          currentWeather['last_updated_epoch'].toInt() * 1000),
    );
  }

  factory Weather.fromForcastJson(Map<String, dynamic> json) {
    return Weather(
      condition: json['day']['condition']['text'],
      icon: 'https:${json['day']['condition']['icon']}',
      conditionId: json['day']['condition']['code'],
      temperature: json['day']['avgtemp_c'].toDouble(),
      humidity: json['day']['avghumidity'].toDouble(),
      pressure: json['hour'][0]['pressure_mb'].toDouble(),
      windSpeed: json['day']['maxwind_kph'].toDouble(),
      realFeel: json['day']['avgtemp_c'].toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(
          json['date_epoch'].toInt() * 1000),
      minTemp: json['day']['mintemp_c'].toDouble(),
      maxTemp: json['day']['maxtemp_c'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'condition': condition,
      'icon': icon,
      'conditionId': conditionId,
      'temperature': temperature,
      'humidity': humidity,
      'pressure': pressure,
      'windSpeed': windSpeed,
      'realFeel': realFeel,
      'date': date.toIso8601String(),
    };
  }
}

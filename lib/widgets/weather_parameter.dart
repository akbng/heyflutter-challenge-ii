import 'package:flutter/material.dart';

class WeatherFeature extends StatelessWidget {
  final IconData icon;

  final String featureName;
  final String value;
  const WeatherFeature({
    super.key,
    required this.icon,
    required this.featureName,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 40,
          color: Colors.white,
        ),
        Text(featureName.toUpperCase()),
        Text(value),
      ],
    );
  }
}

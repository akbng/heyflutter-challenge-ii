import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/utils/file_utils.dart';
import 'package:weather_app/models/weather_forecast.dart';
import 'package:weather_app/models/weather.dart';

@GenerateNiceMocks([MockSpec<Weather>()])
import "forecast_test.mocks.dart";

void main() {
  // TODO: check the dates of the forecast it's messed up
  test('Forecast.fromJson should parse JSON correctly', () async {
    final sampleData =
        await readJsonFile('test/mock_data/weather_forecast.json');
    final forecast = WeatherForecast.fromJson(sampleData);

    expect(forecast.currentWeather.condition, 'Clouds');
    expect(forecast.currentWeather.temperature, 21.97);
    expect(forecast.currentWeather.humidity, 83);
    expect(forecast.currentWeather.pressure, 1014);
    expect(forecast.currentWeather.windSpeed, 3);
    expect(forecast.currentWeather.realFeel, 22.39);

    expect(forecast.forecasts[0].condition, 'Clouds');
    expect(forecast.forecasts[0].temperature, 21.65);
    expect(forecast.forecasts[0].humidity, 76);
    expect(forecast.forecasts[0].pressure, 1014);
    expect(forecast.forecasts[0].windSpeed, 2.73);
    expect(forecast.forecasts[0].realFeel, 21.86);

    expect(forecast.forecasts[1].condition, 'Clouds');
    expect(forecast.forecasts[1].temperature, 23.67);
    expect(forecast.forecasts[1].humidity, 55);
    expect(forecast.forecasts[1].pressure, 1014);
    expect(forecast.forecasts[1].windSpeed, 2.13);
    expect(forecast.forecasts[1].realFeel, 23.53);

    expect(forecast.forecasts[2].condition, 'Rain');
    expect(forecast.forecasts[2].temperature, 21.8);
    expect(forecast.forecasts[2].humidity, 92);
    expect(forecast.forecasts[2].pressure, 1012);
    expect(forecast.forecasts[2].windSpeed, 5.46);
    expect(forecast.forecasts[2].realFeel, 22.44);

    expect(forecast.forecasts[3].condition, 'Clouds');
    expect(forecast.forecasts[3].temperature, 19.74);
    expect(forecast.forecasts[3].humidity, 95);
    expect(forecast.forecasts[3].pressure, 1011);
    expect(forecast.forecasts[3].windSpeed, 4.82);
    expect(forecast.forecasts[3].realFeel, 20.25);

    expect(forecast.location, "Kolkata");
  });

  test('creates WeatherForecast with required parameters', () {
    final mockWeather = MockWeather();
    const location = 'London';
    const temp = 20.0;
    final forecast =
        WeatherForecast(currentWeather: mockWeather, location: location);

    expect(forecast.currentWeather, mockWeather);
    expect(forecast.location, location);
    expect(forecast.day2, isNull);
    expect(forecast.day3, isNull);
    expect(forecast.day4, isNull);
    expect(forecast.day5, isNull);

    when(mockWeather.temperature).thenReturn(temp);
    expect(mockWeather.temperature, (temp));
    verify(mockWeather.temperature);
    verifyNoMoreInteractions(mockWeather);
  });
}

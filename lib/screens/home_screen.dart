import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:weather_app/models/location.dart';
import 'package:weather_app/models/weather_forecast.dart';
import 'package:weather_app/screens/locations.dart';
import 'package:weather_app/services/weather_services.dart';
import 'package:weather_app/widgets/forecast.dart';
import 'package:weather_app/widgets/weather_parameter.dart';

class HomeScreen extends StatefulWidget {
  final Location currentPos;
  const HomeScreen({super.key, required this.currentPos});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _weatherService = WeatherService('e71d0b53dfb243b161d181f13a8d99fd');
  final _currentDate = DateTime.now();
  DateTime? _lastUpdateTime;
  WeatherForecast? _forecast;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Container(
          width: 100.w,
          height: 100.h,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            image: DecorationImage(
              image: widget.currentPos.image == null
                  ? const AssetImage("assets/images/img_frame_one.png")
                  : NetworkImage(widget.currentPos.image!)
                      as ImageProvider<Object>,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.darken),
            ),
          ),
          child: RefreshIndicator(
            onRefresh: _fetchWeatherForecast,
            triggerMode: RefreshIndicatorTriggerMode.onEdge,
            child: Scaffold(
              key: _scaffoldKey,
              primary: true,
              backgroundColor: Colors.transparent,
              endDrawer: const Drawer(
                width: double.infinity,
                child: SavedLocations(),
              ),
              appBar: _buildAppBar(),
              body: _buildBody(),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _fetchWeatherForecast();
    super.initState();
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      toolbarHeight: 10.h,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      leading: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Icon(
          Icons.location_on,
          size: 40,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
        child: Text(widget.currentPos.name),
      ),
      titleSpacing: 0,
      actions: [
        IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openEndDrawer();
          },
          icon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Icon(
              Icons.menu,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return ListView(
      children: [
        Column(
          children: [
            Text(
              DateFormat('MMMM dd').format(_currentDate),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            Text(
              "Updated ${DateFormat('dd/M/yyyy hh:mm a').format(_lastUpdateTime ?? _currentDate)}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Image.asset(
              "assets/images/weather.png",
              height: 16.h,
            ),
            Text(
              _forecast?.currentWeather.condition ?? "",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            Text(
              "${_forecast?.currentWeather.temperature.round()}°C",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 50,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              WeatherFeature(
                icon: Icons.water_drop_outlined,
                featureName: "humidity",
                value: "${_forecast?.currentWeather.humidity.toInt() ?? 0}%",
              ),
              WeatherFeature(
                icon: Icons.air_outlined,
                featureName: "wind speed",
                value: "${_forecast?.currentWeather.windSpeed ?? 0}km/h",
              ),
              WeatherFeature(
                icon: Icons.thermostat_outlined,
                featureName: "feels like",
                value: "${_forecast?.currentWeather.realFeel.round() ?? 0}°C",
              ),
            ],
          ),
        ),
        DailyForecastCard(forecast: _forecast?.forecasts ?? []),
      ],
    );
  }

  Future<void> _fetchWeatherForecast() async {
    final latitude = widget.currentPos.latitude;
    final longitude = widget.currentPos.longitude;

    try {
      final weatherForecast = await _weatherService.getWeatherForecast(
        lat: latitude,
        long: longitude,
      );

      setState(() {
        _forecast = weatherForecast;
        _lastUpdateTime = DateTime.now();
      });
    } catch (error) {
      print(error);
    }
  }
}
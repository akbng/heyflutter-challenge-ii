import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:weather_app/core/utils/date_time_utils.dart';
import 'package:weather_app/models/location.dart';
import 'package:weather_app/models/weather_forecast.dart';
import 'package:weather_app/screens/locations.dart';
import 'package:weather_app/services/weather_services.dart';
import 'package:weather_app/widgets/forecast.dart';
import 'package:weather_app/widgets/helper/show_error_snackbar.dart';
import 'package:weather_app/widgets/weather_parameter.dart';

class HomeScreen extends StatefulWidget {
  final Location currentPos;
  const HomeScreen({super.key, required this.currentPos});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _weatherService = WeatherService();
  final _currentDate = DateTime.now();
  DateTime _lastUpdateTime = DateTime.now();
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
              resizeToAvoidBottomInset: true,
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
      leading: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Icon(
          Icons.location_on,
          size: 40,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
        child: Text(widget.currentPos.name, overflow: TextOverflow.ellipsis),
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
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: 85.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  _currentDate.format('MMMM dd'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
                Text(
                  "Updated ${_lastUpdateTime.format('dd/M/yyyy hh:mm a')}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                _forecast?.currentWeather.icon == null
                    ? Image.asset(
                        "assets/images/weather.png",
                        height: 16.h,
                      )
                   : Image.network(_forecast!.currentWeather.icon!),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    _forecast?.currentWeather.condition ?? "loading",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "${_forecast?.currentWeather.temperature.round() ?? 0}°C",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 56, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      WeatherFeature(
                        icon: Icons.water_drop_outlined,
                        featureName: "humidity",
                        value:
                            "${_forecast?.currentWeather.humidity.toInt() ?? 0}%",
                      ),
                      WeatherFeature(
                        icon: Icons.air_outlined,
                        featureName: "wind speed",
                        value:
                            "${_forecast?.currentWeather.windSpeed ?? 0}km/h",
                      ),
                      WeatherFeature(
                        icon: Icons.thermostat_outlined,
                        featureName: "feels like",
                        value:
                            "${_forecast?.currentWeather.realFeel.round() ?? 0}°C",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                DailyForecastCard(forecast: _forecast?.forecasts ?? []),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _fetchWeatherForecast() async {
    final latitude = widget.currentPos.latitude;
    final longitude = widget.currentPos.longitude;

    try {
      final weatherForecast = await _weatherService.getWeatherForecastCoords(
        lat: latitude,
        long: longitude,
      );
      if (mounted) {
        setState(() {
          _forecast = weatherForecast;
          _lastUpdateTime = DateTime.now();
        });
      }
    } catch (error) {
      if (context.mounted) {
        showErrorSnackbar(context, error.toString().substring(11));
      }
    }
  }
}

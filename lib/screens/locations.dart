import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_app/models/location.dart';
import 'package:weather_app/services/storage_services.dart';
import 'package:weather_app/widgets/add_location.dart';
import 'package:weather_app/widgets/location_searchbar.dart';

import '../widgets/saved_location.dart';

class SavedLocations extends StatefulWidget {
  const SavedLocations({super.key});

  @override
  State<SavedLocations> createState() => _SavedLocationsState();
}

class _SavedLocationsState extends State<SavedLocations> {
  List<Location> _savedLocations = [];

  @override
  void initState() {
    _fetchSavedLocations();
    super.initState();
  }

  Future<void> _fetchSavedLocations() async {
    // TODO: do not save currentPos to the device, coz it can be shared by global state provider
    // which is already installed - GetX
    final currentPos = await StorageServices.getString('current_position');
    var savedLocations = await StorageServices.getStringList('saved_locations');

    final pos = Location.fromJson(jsonDecode(currentPos));
    bool isCurrentLocationSaved = savedLocations
        .map((location) => Location.fromJson(jsonDecode(location)))
        .any(
          (location) =>
              '${location.name},${location.country}'.toLowerCase() ==
              '${pos.name},${pos.country}'.toLowerCase(),
        );
    if (!isCurrentLocationSaved) {
      savedLocations = [currentPos, ...savedLocations];
      StorageServices.setStringList(
        key: "saved_locations",
        value: savedLocations,
      );
    }

    setState(() {
      _savedLocations = savedLocations
          .map((location) => Location.fromJson(jsonDecode(location)))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF391A49),
            Color(0xFF301D5C),
            Color(0xFF262171),
            Color(0xFF301D5C),
            Color(0xFF391A49),
          ],
          stops: [0.112, 0.324, 0.559, 0.693, 0.895],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Saved Locations",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 20, fontWeight: FontWeight.normal),
                  ),
                  const LocationSearchbarWidget()
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (ctx, index) => SavedLocationWidget(
                    savedLocation: _savedLocations[index],
                  ),
                  itemCount: _savedLocations.length,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAAA5A5).withOpacity(0.5),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    _openAddLocationOverlay(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle_outline),
                        SizedBox(width: 12),
                        Text("Add new"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openAddLocationOverlay(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (ctx) => const AddLocationWidget(),
    );
    if (result != null && result.runtimeType == Location && context.mounted) {
      setState(() {
        _savedLocations = [..._savedLocations, result];
      });
    }
  }
}

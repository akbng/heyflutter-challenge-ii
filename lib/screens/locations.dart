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
    final savedLocations =
        await StorageServices.getStringList('saved_locations');

    final isCurrentLocationSaved = savedLocations.contains(currentPos);
    if (!isCurrentLocationSaved) {
      StorageServices.setStringList(
        key: "saved_locations",
        value: [currentPos, ...savedLocations],
      );
    }

    setState(() {
      _savedLocations = savedLocations
          .map((location) => Location.fromJson(jsonDecode("[$location]")))
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Saved Locations",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  LocationSearchbarWidget()
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (ctx, index) => SavedLocationWidget(
                    savedLocation: _savedLocations[index],
                  ),
                  itemCount: _savedLocations.length,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
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

  void _openAddLocationOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (ctx) => const AddLocationWidget(),
    );
  }
}

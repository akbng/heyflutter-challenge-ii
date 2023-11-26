import 'package:flutter/material.dart';
import 'package:weather_app/models/location_suggestion.dart';
import 'package:weather_app/widgets/image_selection.dart';

import '../models/location_image.dart';
import '../services/location_services.dart';
import 'location_autocomplete.dart';

class AddLocationWidget extends StatefulWidget {
  const AddLocationWidget({super.key});

  @override
  State<AddLocationWidget> createState() => _AddLocationWidgetState();
}

class _AddLocationWidgetState extends State<AddLocationWidget> {
  LocationSuggestion? _selectedLocation;
  List<LocationImage> _selectedLocationImages = [];
  LocationImage? _selectedImage;
  final _locationServices = LocationService();

  void setselectedLocation(LocationSuggestion location) {
    setState(() {
      _selectedLocation = location;
    });
    _fetchLocationImages();
  }

  void setSelectedImage(LocationImage image) {
    setState(() {
      _selectedImage = image;
    });
  }

  Future<void> _fetchLocationImages() async {
    final images =
        await _locationServices.getLocationImages(_selectedLocation!.cityName);
    setState(() {
      _selectedLocationImages = images;
    });
  }

  void onCancel() {
    Navigator.of(context).pop();
  }

  Future<void> saveSelectedLocation(BuildContext context) async {
    if (_selectedLocation != null) {
      try {
        final location = await _locationServices
            .getPlaceDetails(_selectedLocation!.cityName);
        await _locationServices.saveLocation(
          location: location,
          image: _selectedImage,
        );
      } catch (e) {
        print(e);
      }

      if (context.mounted) Navigator.of(context).pop(_selectedLocation);
    }
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Text(
              "Add Location",
              style:
                  Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 24),
            ),
            LocationAutoCompleteWidget(handleSelection: setselectedLocation),
            const SizedBox(height: 16),
            Text("Select Image:", style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            Expanded(
              child: _selectedLocationImages.isNotEmpty
                  ? ImageSelectionWidget(
                      images: _selectedLocationImages,
                      onSelect: setSelectedImage,
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 48,
                            color: Colors.white,
                          ),
                          SizedBox(height: 20),
                          Text("Please select a location first"),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    saveSelectedLocation(context);
                  },
                  icon: const Icon(Icons.check_circle_outlined),
                  label: const Text("Save"),
                ),
                ElevatedButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text("Cancel"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

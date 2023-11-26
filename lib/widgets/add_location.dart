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
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            const Text("Add Location"),
            LocationAutoCompleteWidget(handleSelection: setselectedLocation),
            const SizedBox(height: 16),
            Expanded(
              child: _selectedLocationImages.isNotEmpty
                  ? ImageSelectionWidget(
                      images: _selectedLocationImages,
                      onSelect: setSelectedImage,
                    )
                  : const Center(
                      child: Text(
                          "Please select a location to before choosing an image"),
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

// 532229 - application id
// Hdt48j6LVVFqNlyeqGZLJI6eNJ7kRu9o5nA03oAdPcw - access key
// iazfES0GOwStaymmj6l9JT3zLMJdaTSGF7IDazSPdp0 - secret key

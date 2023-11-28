import 'package:flutter/material.dart';
import 'package:weather_app/models/location.dart';
import 'package:weather_app/widgets/image_selection.dart';

import '../models/location_image.dart';
import '../services/location_services.dart';
import 'location_autocomplete.dart';

class AddLocationWidget extends StatefulWidget {
  final Location? location;

  const AddLocationWidget({super.key, this.location});

  @override
  State<AddLocationWidget> createState() => _AddLocationWidgetState();
}

class _AddLocationWidgetState extends State<AddLocationWidget> {
  Location? _selectedLocation;
  List<LocationImage> _selectedLocationImages = [];
  LocationImage? _selectedImage;
  final _locationServices = LocationService();
  bool loadingImages = false;

  void setselectedLocation(Location location) {
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
    final location = widget.location ?? _selectedLocation;

    if (location == null) {
      showError(context, "no location set");
    } else {
      setState(() {
        loadingImages = true;
      });
      try {
        final images = await _locationServices.getLocationImages(location.name);
        setState(() {
          _selectedLocationImages = images;
        });
      } catch (error) {
        if (context.mounted) {
          showError(context, error.toString().substring(11));
        }
      } finally {
        if (context.mounted) {
          setState(() {
            loadingImages = false;
          });
        }
      }
    }
  }

  void onCancel() {
    Navigator.of(context).pop();
  }

  Future<void> saveSelectedLocation(BuildContext context) async {
    try {
      if (_selectedLocation == null) {
        throw Exception("Please select a location first!");
      }
      await _locationServices.saveLocation(
        location: _selectedLocation!,
        image: _selectedImage,
      );

      if (context.mounted) Navigator.of(context).pop(_selectedLocation);
    } catch (error) {
      if (context.mounted) {
        showError(context, error.toString().substring(11));
      }
    }
  }

  Future<void> updateLocation(BuildContext context) async {
    try {
      if (_selectedImage == null) throw Exception("Please select an Image");
      await _locationServices.updateLocation(
        location: widget.location!,
        image: _selectedImage!,
      );

      var newLoc = widget.location!;
      newLoc.setImage(_selectedImage!.url, _selectedImage!.blurHash);
      if (context.mounted) Navigator.of(context).pop(newLoc);
    } catch (error) {
      if (context.mounted) {
        showError(context, error.toString().substring(11));
      }
    }
  }

  void showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.location != null) _fetchLocationImages();
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
              "${widget.location == null ? 'Add' : 'Update'} Location",
              style:
                  Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 24),
            ),
            if (widget.location == null)
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
                  : Center(
                      child: loadingImages
                          ? const CircularProgressIndicator()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline_rounded,
                                  size: 48,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 20),
                                Text(widget.location == null
                                    ? "Please select a location first"
                                    : "Could not find an Image!"),
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
                    if (widget.location == null) {
                      saveSelectedLocation(context);
                    } else {
                      updateLocation(context);
                    }
                  },
                  icon: const Icon(Icons.check_circle_outlined),
                  label: Text(widget.location == null ? "Save" : "Update"),
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

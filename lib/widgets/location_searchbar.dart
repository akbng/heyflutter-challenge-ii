import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_app/screens/home_screen.dart';

import '../models/location.dart';
import '../services/storage_services.dart';

class LocationSearchbarWidget extends StatelessWidget {
  const LocationSearchbarWidget({super.key});

  Future<void> _showSearchBar(BuildContext context) async {
    final selectedLocation = await showSearch(
      context: context,
      delegate: MySearchDelegate(),
    );

    if (selectedLocation != null && context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => HomeScreen(currentPos: selectedLocation),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        _showSearchBar(context);
      },
      icon: const Icon(Icons.search_rounded, color: Colors.white, size: 40),
    );
  }
}

class MySearchDelegate extends SearchDelegate<Location?> {
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back),
      );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = "";
          }
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Location>>(
      future: _searchSavedLocation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // TODO: add error handling with snapshot.hasError
          if (snapshot.data != null && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  iconColor: Colors.white,
                  textColor: Colors.white,
                  leading: const Icon(Icons.location_on),
                  title: Text(
                    '${snapshot.data?[index].name}, ${snapshot.data?[index].country}',
                  ),
                  onTap: () {
                    close(context, snapshot.data?[index]);
                  },
                );
              },
              itemCount: snapshot.data?.length ?? 0,
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 100,
                  color: Colors.white,
                ),
                Text(
                  "No Locations Found!",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<List<Location>> _searchSavedLocation() async {
    final savedLocations =
        await StorageServices.getStringList('saved_locations');

    return savedLocations
        .map((location) => Location.fromJson(jsonDecode("[$location]")))
        .where((location) => '${location.name}, ${location.country}'
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
  }
}

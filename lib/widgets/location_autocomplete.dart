import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_app/models/location_suggestion.dart';
import 'package:weather_app/services/location_services.dart';

const Duration debounceDuration = Duration(milliseconds: 500);

class LocationAutoCompleteWidget extends StatefulWidget {
  const LocationAutoCompleteWidget({super.key, required this.handleSelection});

  final void Function(LocationSuggestion) handleSelection;

  @override
  State<LocationAutoCompleteWidget> createState() =>
      _LocationAutoCompleteWidgetState();
}

class _LocationAutoCompleteWidgetState
    extends State<LocationAutoCompleteWidget> {
  // The query currently being searched for. If null, there is no pending
  // request.
  String? _currentQuery;
  final _locationServices = LocationService();

  // The most recent options received from the API.
  late Iterable<LocationSuggestion> _lastOptions = <LocationSuggestion>[];

  late final _Debounceable<Iterable<LocationSuggestion>?, String>
      _debouncedSearch;

  // Calls the "remote" API to search with the given query. Returns null when
  // the call has been made obsolete.
  Future<Iterable<LocationSuggestion>?> _search(String query) async {
    _currentQuery = query;

    if (query.isEmpty) {
      return null;
    }

    // In a real application, there should be some error handling here.
    final List<LocationSuggestion> options =
        await _locationServices.getLocationSuggestions(query);

    // If another search happened after this one, throw away these options.
    if (_currentQuery != query) {
      return null;
    }
    _currentQuery = null;

    return options;
  }

  @override
  void initState() {
    super.initState();
    _debouncedSearch =
        _debounce<Iterable<LocationSuggestion>?, String>(_search);
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<LocationSuggestion>(
      displayStringForOption: (option) =>
          "${option.cityName}, ${option.country}",
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Search for a location...',
            filled: true,
            fillColor: Colors.white30,
            hintStyle: TextStyle(color: Colors.white60),
          ),
          controller: textEditingController,
          focusNode: focusNode,
          onSubmitted: (text) {
            onFieldSubmitted();
          },
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<LocationSuggestion> onSelected,
          Iterable<LocationSuggestion> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                padding: const EdgeInsets.all(4),
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final option = options.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      onSelected(option);
                    },
                    child: ListTile(
                      title: Text(option.cityName),
                      subtitle: Text(option.country),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      optionsBuilder: (TextEditingValue textEditingValue) async {
        final Iterable<LocationSuggestion>? options =
            await _debouncedSearch(textEditingValue.text);
        if (options == null) {
          return _lastOptions;
        }
        _lastOptions = options;
        return options;
      },
      onSelected: (LocationSuggestion selection) {
        widget.handleSelection(selection);
      },
    );
  }
}

typedef _Debounceable<S, T> = Future<S?> Function(T parameter);

/// Returns a new function that is a debounced version of the given function.
///
/// This means that the original function will be called only after no calls
/// have been made for the given Duration.
_Debounceable<S, T> _debounce<S, T>(_Debounceable<S?, T> function) {
  _DebounceTimer? debounceTimer;

  return (T parameter) async {
    if (debounceTimer != null && !debounceTimer!.isCompleted) {
      debounceTimer!.cancel();
    }
    debounceTimer = _DebounceTimer();
    try {
      await debounceTimer!.future;
    } catch (error) {
      if (error is _CancelException) {
        return null;
      }
      rethrow;
    }
    return function(parameter);
  };
}

// A wrapper around Timer used for debouncing.
class _DebounceTimer {
  _DebounceTimer() {
    _timer = Timer(debounceDuration, _onComplete);
  }

  late final Timer _timer;
  final Completer<void> _completer = Completer<void>();

  void _onComplete() {
    _completer.complete();
  }

  Future<void> get future => _completer.future;

  bool get isCompleted => _completer.isCompleted;

  void cancel() {
    _timer.cancel();
    _completer.completeError(const _CancelException());
  }
}

// An exception indicating that the timer was canceled.
class _CancelException implements Exception {
  const _CancelException();
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:qolshatyr_mobile/src/services/location_service.dart';
import 'package:qolshatyr_mobile/src/models/trip.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/base/map';
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LocationService _locationService = LocationService();
  LatLng? currentPosition;
  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getLastLocation();
      _locationSubscription = _locationService.getLocationUpdates().listen(
        (LocationData currentLocation) {
          _updateLocation(currentLocation);
        },
      );
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return currentPosition == null
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text('Please turn on the location'),
              ],
            ),
          )
        : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentPosition!,
              zoom: 13,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('Me'),
                position: currentPosition!,
              ),
            },
          );
  }

  Future<void> _showInitialDialog() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Initial Dialog'),
          content: const Text('This is the initial dialog.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // _showBottomSheet();
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Create a New Trip'),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Create a new Trip instance here
                  Trip newTrip = Trip(
                    startLocation: LocationData.fromMap({
                      'latitude': currentPosition!.latitude,
                      'longitude': currentPosition!.longitude
                    }),
                    endLocation:
                        LocationData.fromMap({'latitude': 0, 'longitude': 0}),
                    estimateDuration: const Duration(hours: 1),
                    startTime: DateTime.now(),
                  );
                  // Do something with the new Trip
                  print('New Trip created: $newTrip');
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: const Text('Create Trip'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getLastLocation() async {
    final lastLocation = await _locationService.getLastLocation();
    print('GAUHAR $lastLocation');
    if (lastLocation != null) {
      setState(() {
        currentPosition =
            LatLng(lastLocation.latitude!, lastLocation.longitude!);
      });
    } else {
      LocationData? currentLocation =
          await _locationService.getCurrentLocation();
      setState(() {
        currentPosition =
            LatLng(currentLocation!.latitude!, currentLocation.longitude!);
      });
      print('HELLO $currentPosition');
    }
  }

  Future<void> _updateLocation(LocationData currentLocation) async {
    setState(() {
      currentPosition =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
    });
    _locationService.saveLastLocation(currentLocation);
  }
}

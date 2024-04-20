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
  TimeOfDay? _estimatedArrivalTime;

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
      _showInitialDialog();
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
    print('DIALOG 1');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        print('DIALOG 2');
        return AlertDialog(
          title: const Text('Send your location to your close ones'),
          content: const Text('This is the initial dialog.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showBottomSheet();
              },
              child: const Text('Next'),
            ),
          ],
        );
      },
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Enter your destination address and estimated arrival time',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  TextButton(
                      onPressed: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _estimatedArrivalTime = picked;
                          });
                        }
                      },
                      child: Text(
                        _estimatedArrivalTime == null ? '00:00' : _estimatedArrivalTime!.format(context),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                        ),
                      )),
                  ElevatedButton(
                    onPressed: () {
                      Trip newTrip = Trip(
                        startLocation: LocationData.fromMap({
                          'latitude': currentPosition!.latitude,
                          'longitude': currentPosition!.longitude,
                        }),
                        endLocation: LocationData.fromMap({
                          'latitude': 0.0,
                          'longitude': 0.0,
                        }),
                        estimateDuration: const Duration(hours: 1),
                        startTime: DateTime.now(),
                      );
                      print('New Trip created: $newTrip');
                      Navigator.pop(context);
                    },
                    child: const Text('Start a trip'),
                  ),
                ],
              ),
            );
          },
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

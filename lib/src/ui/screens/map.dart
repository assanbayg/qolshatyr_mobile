// IMPORTANT TODO:
// once you start publishing this app, change the way you secure your Google Maps API
// for now local.properties is okay but be careful, Gauhar from the future

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:qolshatyr_mobile/src/services/location_service.dart';

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
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure),
                position: currentPosition!,
              ),
            },
          );
  }

  Future<void> _getLastLocation() async {
    final lastLocation = await _locationService.getLastLocation();
    if (lastLocation != null) {
      setState(() {
        currentPosition =
            LatLng(lastLocation.latitude!, lastLocation.longitude!);
      });
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

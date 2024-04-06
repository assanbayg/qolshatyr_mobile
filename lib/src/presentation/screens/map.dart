// IMPORTANT ToDo:
// once you start publishing this app, change the way you secure your Google Maps API
// for now local.properties is okay but be careful, Gauhar from the future

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/map';
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Location locationController = Location();

  // Almaty Location
  // ToDo: detect city location automatically or use another location
  static const googlePlex = LatLng(43.238949, 76.889709);

  LatLng? currentPosition;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchLocationUpdates();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return currentPosition == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: googlePlex,
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

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
      }
    });
  }
}

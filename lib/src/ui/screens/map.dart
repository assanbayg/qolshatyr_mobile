import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qolshatyr_mobile/src/providers/trip_provider.dart';
import 'package:qolshatyr_mobile/src/services/dialog_service.dart';
import 'package:qolshatyr_mobile/src/services/location_service.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/base/map';
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LocationService _locationService = LocationService();
  final DialogService _dialogService = DialogService();
  LatLng? currentPosition;
  LatLng? endPosition;
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
      if (mounted) {
        _dialogService.showInitialDialog(
            context,
            LocationData.fromMap({
              'latitude': currentPosition!.latitude,
              'longitude': currentPosition!.longitude,
            }));
      }
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
        : Consumer(
            builder: (context, ref, child) {
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: currentPosition!,
                  zoom: 13,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('Me'),
                    position: currentPosition!,
                  ),
                  Marker(
                    markerId: const MarkerId('B'),
                    position: endPosition ?? currentPosition!,
                  ),
                },
                onTap: (LatLng location) {
                  setState(() {
                    endPosition = location;
                  });
                  ref
                      .read(tripProvider.notifier)
                      .updateEndLocation(LocationData.fromMap({
                        'latitude': endPosition!.latitude,
                        'longitude': endPosition!.longitude,
                      }));
                },
              );
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
    } else {
      LocationData? currentLocation =
          await _locationService.getCurrentLocation();
      setState(() {
        currentPosition =
            LatLng(currentLocation!.latitude!, currentLocation.longitude!);
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

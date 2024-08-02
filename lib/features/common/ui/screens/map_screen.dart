// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/trip/services/location_service.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/base/map';
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<MapScreen> {
  final LocationService _locationService = LocationService();
  LocationData? _currentLocation;
  LocationData? _endLocation;
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
    final localization = AppLocalizations.of(context)!;

    return _currentLocation == null
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                Text(localization.turnOnLocation),
              ],
            ),
          )
        : Consumer(
            builder: (context, ref, child) {
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(_currentLocation!.latitude!,
                      _currentLocation!.longitude!),
                  //  _currentLocation!,
                  zoom: 13,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('Me'),
                    position: LatLng(_currentLocation!.latitude!,
                        _currentLocation!.longitude!),
                  ),
                  if (_endLocation != null)
                    Marker(
                        position: LatLng(
                          _endLocation!.latitude!,
                          _endLocation!.longitude!,
                        ),
                        markerId: const MarkerId('B'),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueAzure)),
                },
                onTap: (LatLng location) {
                  setState(() {
                    _endLocation = LocationData.fromMap({
                      'latitude': location.latitude,
                      'longitude': location.longitude
                    });
                    // endPosition = location;
                  });
                },
              );
            },
          );
  }

  Future<void> _getLastLocation() async {
    final LocationData? lastLocation = await _locationService.getLastLocation();
    if (lastLocation != null) {
      setState(() {
        _currentLocation = lastLocation;
      });
    } else {
      if (mounted) {
        final newLocation = await _locationService.getCurrentLocation(context);
        setState(() {
          _currentLocation = newLocation;
        });
      }
    }
  }

  Future<void> _updateLocation(LocationData currentLocation) async {
    setState(() {});
    _locationService.saveLastLocation(currentLocation);
  }
}

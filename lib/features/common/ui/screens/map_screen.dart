// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/trip/services/location_service.dart';
import 'package:qolshatyr_mobile/features/trip/trip_provider.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/base/map';
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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
              return FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(
                      _currentLocation!.latitude!,
                      _currentLocation!.longitude!,
                    ),
                    initialZoom: 11,
                    onTap: (tapPosition, point) {
                      setState(() {
                        _endLocation = LocationData.fromMap({
                          "latitude": point.latitude,
                          "longitude": point.longitude
                        });
                      });
                      ref
                          .read(tripProvider.notifier)
                          .updateEndLocation(_endLocation!);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.qolshatyr.qolshatyr_mobile',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(
                            _currentLocation!.latitude!,
                            _currentLocation!.longitude!,
                          ),
                          child: const Icon(
                            Icons.location_on_rounded,
                            color: Colors.red,
                          ),
                        ),
                        if (_endLocation != null)
                          Marker(
                            point: LatLng(
                              _endLocation!.latitude!,
                              _endLocation!.longitude!,
                            ),
                            child: const Icon(
                              Icons.location_on_rounded,
                              color: Colors.blue,
                            ),
                          ),
                      ],
                    ),
                  ]);
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

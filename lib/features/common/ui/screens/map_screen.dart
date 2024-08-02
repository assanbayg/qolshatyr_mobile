// Dart imports:
import 'dart:async';
import 'dart:developer';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/services/geocoding_service.dart';
import 'package:qolshatyr_mobile/features/trip/services/location_service.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/base/map';
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<MapScreen> {
  final LocationService _locationService = LocationService();
  final Completer<GoogleMapController> _mapController = Completer();
  final TextEditingController _addressController = TextEditingController();
  LocationData? _currentLocation;
  LocationData? _endLocation;
  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeLocation();
    });
  }

  @override
  void dispose() {
    _disposeResources();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Stack(
      children: [
        _buildMap(localization),
        _buildSearchCard(localization),
      ],
    );
  }

  Future<void> _initializeLocation() async {
    await _getLastLocation();
    _locationSubscription = _locationService.getLocationUpdates().listen(
      (LocationData currentLocation) {
        _updateLocation(currentLocation);
      },
    );
  }

  void _disposeResources() {
    _locationSubscription?.cancel();
    _addressController.dispose();
  }

  Widget _buildMap(AppLocalizations localization) {
    return _currentLocation == null
        ? _buildLoadingIndicator(localization)
        : Consumer(
            builder: (context, ref, child) {
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    _currentLocation!.latitude!,
                    _currentLocation!.longitude!,
                  ),
                  zoom: 13,
                ),
                markers: _buildMarkers(),
                onTap: _handleMapTap,
                onMapCreated: (GoogleMapController controller) {
                  _mapController.complete(controller);
                },
              );
            },
          );
  }

  Widget _buildLoadingIndicator(AppLocalizations localization) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          Text(localization.turnOnLocation),
        ],
      ),
    );
  }

  Widget _buildSearchCard(AppLocalizations localization) {
    return Positioned(
      top: 10,
      left: 15,
      right: 15,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _addressController,
                  decoration:
                      InputDecoration(hintText: localization.enterAddress),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: _handleSearch,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Set<Marker> _buildMarkers() {
    return {
      Marker(
        markerId: const MarkerId('Me'),
        position: LatLng(
          _currentLocation!.latitude!,
          _currentLocation!.longitude!,
        ),
      ),
      if (_endLocation != null)
        Marker(
          position: LatLng(
            _endLocation!.latitude!,
            _endLocation!.longitude!,
          ),
          markerId: const MarkerId('B'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
    };
  }

  void _handleMapTap(LatLng location) async {
    setState(() {
      _endLocation = LocationData.fromMap(
          {'latitude': location.latitude, 'longitude': location.longitude});
    });

    List<Placemark> res = await GeocodingService.translateFromLatLng(
      LocationData.fromMap(
          {'latitude': location.latitude, 'longitude': location.longitude}),
    );
    setState(() {
      _addressController.text = res[0].street!;
    });
  }

  void _handleSearch() async {
    String address = _addressController.text;
    List<Placemark> myLocation = await GeocodingService.translateFromLatLng(
      LocationData.fromMap(
        {
          'latitude': _currentLocation!.latitude,
          'longitude': _currentLocation!.longitude,
        },
      ),
    );
    String res =
        "$address, ${myLocation[0].administrativeArea!}, ${myLocation[0].country!}";

    if (address.isNotEmpty) {
      log(res);
      List<LocationData> locations =
          await GeocodingService.translateToLatLng(res);
      if (locations.isNotEmpty) {
        log(locations.first.toString());
        LocationData location = locations.first;
        LatLng latLng = LatLng(location.latitude!, location.longitude!);
        _updateMapLocation(latLng);
      }
    }
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
    setState(() {
      _currentLocation = currentLocation;
    });
    _locationService.saveLastLocation(currentLocation);
  }

  Future<void> _updateMapLocation(LatLng latLng) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newLatLng(latLng));
    setState(() {
      _endLocation = LocationData.fromMap({
        'latitude': latLng.latitude,
        'longitude': latLng.longitude,
      });
    });
  }
}

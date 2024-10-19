// Dart imports:
import 'dart:async';

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
import 'package:qolshatyr_mobile/features/common/ui/widgets/loading_indicator.dart';
import 'package:qolshatyr_mobile/features/common/utils/geojson_utils.dart';
import 'package:qolshatyr_mobile/features/map/widgets/map_markers.dart';
import 'package:qolshatyr_mobile/features/map/widgets/search_card.dart';
import 'package:qolshatyr_mobile/features/trip/services/location_service.dart';
import 'package:qolshatyr_mobile/features/trip/trip_provider.dart';

class MapScreen extends ConsumerStatefulWidget {
  static const routeName = '/base/map';
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends ConsumerState<MapScreen> {
  final LocationService _locationService = LocationService();
  final Completer<GoogleMapController> _mapController = Completer();
  final TextEditingController _addressController = TextEditingController();
  LocationData? _currentLocation;
  StreamSubscription<LocationData>? _locationSubscription;

  Set<Polyline> polylines = {};

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
    final tripNotifier = ref.read(tripProvider.notifier);

    return Stack(
      children: [
        _buildMap(localization, tripNotifier.latestTrip.startLocation,
            tripNotifier.latestTrip.endLocation),
        SearchCard(
          onSearch: () => _handleSearch(),
          addressController: _addressController,
        ),
        _buildButtons(localization),
      ],
    );
  }

  Future<void> _initializeLocation() async {
    await _getLastLocation();
    _locationSubscription = _locationService.getLocationUpdates().listen(
      (LocationData currentLocation) {
        _updateCurrentLocation(currentLocation);
      },
    );
  }

  void _disposeResources() {
    _locationSubscription?.cancel();
    _addressController.dispose();
  }

  Widget _buildMap(AppLocalizations localization, LocationData? startLocation,
      LocationData? endLocation) {
    return _currentLocation == null
        ? const LoadingIndicator()
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
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                compassEnabled: true,
                markers: MapMarkers.buildMarkers(startLocation, endLocation),
                polylines: polylines,
                onTap: (location) => _handleMapTap(location),
                onMapCreated: (GoogleMapController controller) {
                  _mapController.complete(controller);
                },
              );
            },
          );
  }

  Widget _buildButtons(AppLocalizations localization) {
    return Positioned(
      bottom: 20,
      left: 15,
      right: 15,
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(elevation: 4),
            onPressed: _importRouteFromGeoJSON,
            child: const Text('Import'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(elevation: 4),
            onPressed: _exportRouteToGeoJSON,
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _handleMapTap(LatLng location) async {
    final newEndLocation = LocationData.fromMap({
      'latitude': location.latitude,
      'longitude': location.longitude,
    });

    // update the end location in the trip provider
    ref.read(tripProvider.notifier).updateEndLocation(newEndLocation);

    // geocode the new location
    Placemark res = await GeocodingService.translateFromLatLng(newEndLocation);
    String newText = "${res.thoroughfare!} ${res.subThoroughfare!}";

    if (res.thoroughfare!.isEmpty == true) {
      newText = "${res.subThoroughfare}, ${res.subLocality}";
    }
    setState(() => _addressController.text = newText);
  }

  void _handleSearch() async {
    String address = _addressController.text;
    Placemark currentLocationPlacemark =
        await GeocodingService.translateFromLatLng(
      LocationData.fromMap(
        {
          'latitude': _currentLocation!.latitude,
          'longitude': _currentLocation!.longitude,
        },
      ),
    );
    String res =
        "$address, ${currentLocationPlacemark.administrativeArea!}, ${currentLocationPlacemark.country!}";

    if (address.isNotEmpty) {
      LocationData location = await GeocodingService.translateToLatLng(res);
      LatLng latLng = LatLng(location.latitude!, location.longitude!);
      ref.read(tripProvider.notifier).updateEndLocation(location);
      setState(() {}); // trigger map updates
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newLatLng(latLng));
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

  // -------- polylines related ---------------

  Future<void> _updateCurrentLocation(LocationData currentLocation) async {
    LatLng currentLatLng = LatLng(
      currentLocation.latitude!,
      currentLocation.longitude!,
    );

    Polyline polyline = const Polyline(
      polylineId: PolylineId('trip_route'),
      color: Color.fromARGB(255, 78, 157, 147),
      width: 5,
      points: [],
    );
    polyline.points.add(currentLatLng);
    polylines.add(polyline);

    setState(() {
      _currentLocation = currentLocation;
      polyline.points.add(currentLatLng);
    });
    _locationService.saveLastLocation(currentLocation);
  }

  void _exportRouteToGeoJSON() async {
    await saveGeoJsonToFile(convertPolylinesToGeoJson(polylines));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully stored route!')));
    }
  }

  void _importRouteFromGeoJSON() async {
    Set<Polyline> importPolylines = await createPolylinesFromGeoJson();

    setState(() {
      polylines = importPolylines;
    });
  }
}

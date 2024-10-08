//TODO: store state of start and end location in riverpod
// because after updating state _endLocation is lost
// so gotta store it till trip ends
// gosh so much work i'm not paid for this

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
import 'package:qolshatyr_mobile/features/trip/services/location_service.dart';
import 'package:qolshatyr_mobile/features/trip/trip_provider.dart';

// import 'package:qolshatyr_mobile/features/common/utils/share_geojson.dart';

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
  LocationData? _startLocation;
  LocationData? _endLocation;
  StreamSubscription<LocationData>? _locationSubscription;

  Set<Polyline> polylines = {};

// uncomment only during development
  // List<LatLng> polylineCoordinates = [
  //   const LatLng(43.21813442382432, 76.8463621661067),
  //   const LatLng(43.21313027612295, 76.85722377151251),
  //   const LatLng(43.23100233570027, 76.87257371842861),
  //   const LatLng(43.236068768829355, 76.88954707235098)
  // ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeLocation();
    });

    // uncomment only during development
    // for (int i = 0; i < polylineCoordinates.length; i++) {
    //   polylines.add(
    //     Polyline(
    //       polylineId: const PolylineId('1'),
    //       points: polylineCoordinates,
    //       color: const Color.fromARGB(255, 78, 157, 147),
    //       width: 4,
    //     ),
    //   );
    //   setState(() {});
    // }
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

  Widget _buildMap(AppLocalizations localization) {
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
                markers: _buildMarkers(),
                polylines: polylines,
                onTap: (location) => _handleMapTap(location, ref),
                onMapCreated: (GoogleMapController controller) {
                  _mapController.complete(controller);
                },
              );
            },
          );
  }

  Widget _buildSearchCard(AppLocalizations localization) {
    return Positioned(
      top: 10,
      left: 15,
      right: 15,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _addressController,
                  // TODO: localize
                  decoration: InputDecoration(
                    hintText: localization.enterAddress,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
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

  Set<Marker> _buildMarkers() {
    return {
      if (_startLocation != null)
        Marker(
            markerId: const MarkerId('A'),
            position: LatLng(
              _startLocation!.latitude!,
              _startLocation!.longitude!,
            )),
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

  void _handleMapTap(LatLng location, WidgetRef ref) async {
    setState(() {
      _endLocation = LocationData.fromMap(
          {'latitude': location.latitude, 'longitude': location.longitude});
    });

    ref.read(tripProvider.notifier).updateEndLocation(_endLocation!);

    Placemark res = await GeocodingService.translateFromLatLng(
      LocationData.fromMap(
          {'latitude': location.latitude, 'longitude': location.longitude}),
    );

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
      _updateEndLocation(latLng);
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

  Future<void> _updateCurrentLocation(LocationData currentLocation) async {
    LatLng currentLatLng = LatLng(
      currentLocation.latitude!,
      currentLocation.longitude!,
    );

    // ignore: prefer_const_constructors
    Polyline polyline = Polyline(
      polylineId: const PolylineId('trip_route'),
      color: const Color.fromARGB(255, 78, 157, 147),
      width: 5,
      // ignore: prefer_const_literals_to_create_immutables
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

  Future<void> _updateEndLocation(LatLng latLng) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newLatLng(latLng));

    setState(() {
      _endLocation = LocationData.fromMap({
        'latitude': latLng.latitude,
        'longitude': latLng.longitude,
      });
    });
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

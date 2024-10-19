// Package imports:
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapMarkers {
  static Set<Marker> buildMarkers(
      LocationData? startLocation, LocationData? endLocation) {
    final Set<Marker> markers = {};

    if (startLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('start'),
          position: LatLng(
            startLocation.latitude!,
            startLocation.longitude!,
          ),
          infoWindow: const InfoWindow(title: 'Start Location'),
        ),
      );
    }

    if (endLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('end'),
          position: LatLng(
            endLocation.latitude!,
            endLocation.longitude!,
          ),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: const InfoWindow(title: 'End Location'),
        ),
      );
    }

    return markers;
  }
}

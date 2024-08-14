import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';

Set<Polyline> _polyline = {};

List<LatLng> latLng = [
  const LatLng(43.21813442382432, 76.8463621661067),
  const LatLng(43.21313027612295, 76.85722377151251),
  const LatLng(43.23100233570027, 76.87257371842861),
  const LatLng(43.236068768829355, 76.88954707235098)
];

void putOnMap() {
  for (int i = 0; i < latLng.length; i++) {
    _polyline.add(
      Polyline(
        polylineId: const PolylineId('1'),
        points: latLng,
        color: const Color.fromARGB(255, 78, 157, 147),
        width: 4,
      ),
    );
  }
}

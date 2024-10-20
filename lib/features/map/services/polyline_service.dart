// Dart imports:
import 'dart:async';
import 'dart:ui';

// Package imports:
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/utils/geojson_utils.dart';

class PolylineService {
  final Set<Polyline> _polylines = {};

  Set<Polyline> get polylines => _polylines;

  void addPolyline(LatLng currentLatLng) {
    Polyline polyline = const Polyline(
      polylineId: PolylineId('trip_route'),
      color: Color.fromARGB(255, 78, 157, 147),
      width: 5,
      points: [],
    );
    polyline.points.add(currentLatLng);
    _polylines.add(polyline);
  }

  void updatePolyline(LatLng currentLatLng) {
    if (_polylines.isNotEmpty) {
      final Polyline polyline = _polylines.first;
      polyline.points.add(currentLatLng);
    }
  }

  Future<void> exportToGeoJson() async {
    await saveGeoJsonToFile(convertPolylinesToGeoJson(_polylines));
  }

  Future<void> importFromGeoJson() async {
    Set<Polyline> importedPolylines = await createPolylinesFromGeoJson();
    _polylines.clear();
    _polylines.addAll(importedPolylines);
  }
}

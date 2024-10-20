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
    // create a new polyline with the currentLatLng as the init point
    Polyline polyline = Polyline(
      polylineId: const PolylineId('trip_route'),
      color: const Color.fromARGB(255, 78, 157, 147),
      width: 5,
      points: [currentLatLng], // Start with the init point
    );
    _polylines.add(polyline);
  }

  void updatePolyline(LatLng currentLatLng) {
    if (_polylines.isNotEmpty) {
      // get the first polyline
      final Polyline polyline = _polylines.first;

      // create a new polyline with updated points
      List<LatLng> updatedPoints = List.from(polyline.points)
        ..add(currentLatLng);

      // replace the old polyline with the new one containing the updated points
      _polylines.remove(polyline);
      _polylines.add(polyline.copyWith(pointsParam: updatedPoints));
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

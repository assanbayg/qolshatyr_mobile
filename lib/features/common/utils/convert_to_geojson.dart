import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

String convertPolylinesToGeoJSON(Set<Polyline> polylines) {
  final features = polylines.map((polyline) {
    final coordinates = polyline.points.map((point) {
      return [point.longitude, point.latitude];
    }).toList();

    return {
      'type': 'Feature',
      'geometry': {
        'type': 'LineString',
        'coordinates': coordinates,
      },
      'properties': {
        'polylineId': polyline.polylineId.value,
        // Add any additional properties here
      },
    };
  }).toList();

  final geoJson = {
    'type': 'FeatureCollection',
    'features': features,
  };

  return jsonEncode(geoJson);
}

// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:file_picker/file_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qolshatyr_mobile/features/common/utils/shared_preferences.dart';

String convertPolylinesToGeoJson(Set<Polyline> polylines) {
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
      },
    };
  }).toList();

  final geoJson = {
    'type': 'FeatureCollection',
    'features': features,
  };

  return jsonEncode(geoJson);
}

Future<void> saveGeoJsonToFile(String geoJson) async {
  String? directoryPath = SharedPreferencesManager.directory;

  if (directoryPath != null) {
    String timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    String filePath = '$directoryPath/route_$timestamp.geojson';
    final file = File(filePath);

    // ensure directory exists
    await file.create(recursive: true);
    await file.writeAsString(geoJson);
  } else {}
}

Future<Set<Polyline>> createPolylinesFromGeoJson() async {
  String? filePath = await pickGeoJsonFile();

  if (filePath == null) {
    return {};
  }

  String geoJsonString = await readFile(filePath);
  final geoJson = jsonDecode(geoJsonString);

  Set<Polyline> polylines = {};

  if (geoJson['type'] == 'FeatureCollection') {
    final features = geoJson['features'];

    for (var feature in features) {
      if (feature['geometry']['type'] == 'LineString') {
        final coordinates = feature['geometry']['coordinates'] as List<dynamic>;
        List<LatLng> points = coordinates.map((coord) {
          return LatLng(coord[1], coord[0]);
        }).toList();

        final polylineId = PolylineId(feature['properties']['polylineId']);

        polylines.add(Polyline(
          polylineId: polylineId,
          points: points,
          color: feature['properties']['color'] != null
              ? Color(int.parse(feature['properties']['color']))
              : Colors.blue, // Default color if not specified
        ));
      }
    }
  }

  return polylines;
}

Future<String?> pickGeoJsonFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    // type: FileType.custom,
    // allowedExtensions: ['json', 'geojson'],
    dialogTitle: 'Please select a GeoJSON file',
    allowMultiple: false,
  );

  if (result != null && result.files.single.path != null) {
    return result.files.single.path;
  } else {
    return null;
  }
}

Future<String> readFile(String filePath) async {
  final file = File(filePath);
  return await file.readAsString();
}

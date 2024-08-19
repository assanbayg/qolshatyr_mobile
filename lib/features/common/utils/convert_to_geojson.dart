// Dart imports:
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

// Package imports:
import 'package:file_picker/file_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  String? directoryPath = await pickDirectory();
  if (directoryPath != null) {
    String timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    String filePath = '$directoryPath/route_$timestamp.geojson';
    final file = File(filePath);
    await file.writeAsString(geoJson);
    log('GeoJSON saved to $filePath');

    // TODO: read the file later
    String fileContent = await readFile(filePath);
    log('File content: $fileContent');
  } else {
    log('No directory selected');
  }
}

Future<String?> pickDirectory() async {
  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

  if (selectedDirectory != null) {
    return selectedDirectory;
  } else {
    // user canceled the picker
    return null;
  }
}

Future<String> readFile(String filePath) async {
  final file = File(filePath);
  return await file.readAsString();
}

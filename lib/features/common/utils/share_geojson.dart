// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'dart:io';

// Future<void> saveAndShareGeoJSON(String geoJson) async {
//   final directory = await getApplicationDocumentsDirectory();
//   final file = File('${directory.path}/route.geojson');
//   await file.writeAsString(geoJson);

//   Share.shareXFiles([XFile(file.path)],
//       text: 'Here is my route in GeoJSON format');
// }

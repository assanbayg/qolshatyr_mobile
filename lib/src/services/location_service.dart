import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  final Location _location = Location();

  Future<LocationData?> getCurrentLocation() async {
    try {
      final serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        final serviceStatusResult = await _location.requestService();
        if (!serviceStatusResult) {
          return null;
        }
      }

      var permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied ||
          permissionGranted == PermissionStatus.deniedForever) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return null;
        }
      }

      return await _location.getLocation();
    } catch (e) {
      print('Failed to get location: $e');
      return null;
    }
  }

  Future<void> saveLastLocation(LocationData location) async {
    print('Save Last Location: $location');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', location.latitude ?? 0);
    await prefs.setDouble('longitude', location.longitude ?? 0);
  }

  Future<LocationData?> getLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final double? latitude = prefs.getDouble('latitude');
    final double? longitude = prefs.getDouble('longitude');

    if (latitude != null && longitude != null) {
      return LocationData.fromMap(
          {'latitude': latitude, 'longitude': longitude});
    } else {
      return null;
    }
  }

  Stream<LocationData> getLocationUpdates() {
    return _location.onLocationChanged;
  }
}

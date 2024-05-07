import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  final Location _location = Location();

  // Get user's current location
  // Requests for accessing user location
  Future<LocationData?> getCurrentLocation(BuildContext context) async {
    try {
      final serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        final serviceStatusResult = await _location.requestService();
        if (!serviceStatusResult) {
          throw LocationServiceException(
              'Location services are disabled. Please enable location services to proceed.');
        }
      }

      var permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied ||
          permissionGranted == PermissionStatus.deniedForever) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          throw LocationPermissionException(
              'Location permission denied. Please grant permission to access your location.');
        }
      }

      return await _location.getLocation();
    } on LocationServiceException catch (e) {
      if (context.mounted) {
        _showSnackBar(context, e.message);
      }
      return null;
    } on LocationPermissionException catch (e) {
      if (context.mounted) {
        _showSnackBar(context, e.message);
      }
      return null;
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, 'Failed to get location. Please try again.');
      }
      return null;
    }
  }

  // Locally saves user's current location for the next launch
  Future<void> saveLastLocation(LocationData location) async {
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

  // Returns stream to watch user's current location during a trip
  Stream<LocationData> getLocationUpdates() {
    return _location.onLocationChanged;
  }

  // Shows SnackBar for user-friendly exception handling
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

// Custom exceptions for location service and permission errors
class LocationServiceException implements Exception {
  final String message;

  LocationServiceException(this.message);
}

class LocationPermissionException implements Exception {
  final String message;

  LocationPermissionException(this.message);
}

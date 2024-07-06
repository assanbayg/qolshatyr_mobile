// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:location/location.dart';

// Project imports:
import 'package:qolshatyr_mobile/src/utils/shared_preferences.dart';

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
    await SharedPreferencesManager.saveLastLocation(location);
  }

  Future<LocationData?> getLastLocation() async {
    return await SharedPreferencesManager.getLastLocation();
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

// Package imports:
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as location;

class GeocodingService {
  // geocoding
  static Future<location.LocationData> translateToLatLng(String address) async {
    // here Location class means lat lng
    List<Location> latLngList = await locationFromAddress(address);

    List<location.LocationData> locationDataList = [];

    for (Location latLng in latLngList) {
      locationDataList.add(
        location.LocationData.fromMap(
          {
            'latitude': latLng.latitude,
            'longitude': latLng.longitude,
          },
        ),
      );
    }
    return locationDataList.first;
  }

  // reverse geocoding
  static Future<Placemark> translateFromLatLng(
      location.LocationData location) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      location.latitude!,
      location.longitude!,
    );
    return placemarks.first;
  }
}

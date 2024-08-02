import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as location;

class GeocodingService {
  // geocoding
  static Future<List<location.LocationData>> translateToLatLng(
      String address) async {
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
    return locationDataList;
  }

  // reverse geocoding
  static Future<List<Placemark>> translateFromLatLng(
      location.LocationData location) async {
    return await placemarkFromCoordinates(
      location.latitude!,
      location.longitude!,
    );
  }
}

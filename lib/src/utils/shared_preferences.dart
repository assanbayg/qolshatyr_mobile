import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String lastLocationKey = 'last_location';

  Future<void> saveLastLocation(double latitude, double longitude) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', latitude);
    await prefs.setDouble('longitude', longitude);
  }

  Future<Map<String, double>> getLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final double? latitude = prefs.getDouble('latitude');
    final double? longitude = prefs.getDouble('longitude');
    if (latitude != null && longitude != null) {
      return {'latitude': latitude, 'longitude': longitude};
    } else {
      return {};
    }
  }
}

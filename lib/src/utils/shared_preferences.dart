// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:qolshatyr_mobile/src/models/contact.dart';

class SharedPreferencesManager {
  static SharedPreferences? _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> saveLastLocation(LocationData location) async {
    await _sharedPreferences!.setDouble('latitude', location.latitude ?? 0);
    await _sharedPreferences!.setDouble('longitude', location.longitude ?? 0);
  }

  static Future<LocationData?> getLastLocation() async {
    final double? latitude = _sharedPreferences!.getDouble('latitude');
    final double? longitude = _sharedPreferences!.getDouble('longitude');

    if (latitude != null && longitude != null) {
      return LocationData.fromMap({
        'latitude': latitude,
        'longitude': longitude,
      });
    } else {
      return null;
    }
  }

  static Future<void> saveContacts(List<Contact> contacts) async {
    final List<String> serializedContacts =
        contacts.map((contact) => jsonEncode(contact.toJson())).toList();
    await _sharedPreferences!.setStringList('contacts', serializedContacts);
  }

  static Future<List<Contact>> getContacts() async {
    final serializedContacts =
        _sharedPreferences!.getStringList('contacts') ?? [];

    final contacts = serializedContacts.map((contactJson) {
      final contactMap = jsonDecode(contactJson);
      contactMap['number'] = contactMap['phoneNumber'];
      return Contact.fromJson(contactMap);
    }).toList();

    return contacts;
  }

  static Future<void> updateTimerDuration(int minutes) async {
    await _sharedPreferences?.setInt('checkinDuration', minutes);
  }

  static int? getTimerDuration() {
    return _sharedPreferences?.getInt('checkinDuration') ?? 15;
  }
}

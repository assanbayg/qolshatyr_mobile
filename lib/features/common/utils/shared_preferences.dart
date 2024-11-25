// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/contacts/contact_model.dart';

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
      return Contact.fromJson(contactMap);
    }).toList();

    return contacts;
  }

  // update telegram username of one user
  static Future<void> updateContactTelegramUsername(
    String phoneNumber,
    String tgUsername,
  ) async {
    final contacts = await getContacts();
    final updatedContacts = contacts.map((contact) {
      if (contact.phoneNumber == phoneNumber) {
        return contact.copyWith(tgUsername: tgUsername);
      }
      return contact;
    }).toList();

    await saveContacts(updatedContacts);
  }

  // updating the chat id of one user
  static Future<void> updateContactChatId(
    String phoneNumber,
    String chatId,
  ) async {
    final contacts = await getContacts();
    final updatedContacts = contacts.map((contact) {
      if (contact.phoneNumber == phoneNumber) {
        return contact.copyWith(chatId: chatId);
      }
      return contact;
    }).toList();

    await saveContacts(updatedContacts);
  }

  // time: in seconds
  static Future<void> updateCheckInReminderDuration(int seconds) async {
    await _sharedPreferences?.setInt('checkinDuration', seconds);
  }

  // time: in seconds - 6000s = 10min
  static int? get checkInReminderDuration =>
      _sharedPreferences?.getInt('checkinDuration') ?? 6000;

  static Future<void> updateSosPhrase(String newPhrase) async {
    if (newPhrase.trim() == "") return;
    await _sharedPreferences?.setString('sosPhrase', newPhrase);
  }

  static String? get sosPhrase =>
      _sharedPreferences?.getString('sosPhrase') ?? 'help';

  static Future<void> setImageURL(String? url) async {
    await _sharedPreferences?.setString('imageURL', url!);
  }

  static String? get directory =>
      _sharedPreferences?.getString('directory') ?? 'no';

  static Future<void> setDirectory(String? newDirectory) async {
    await _sharedPreferences?.setString('directory', newDirectory!);
  }

  static String? get imageURL =>
      _sharedPreferences?.getString('imageURL') ?? '';
}

bool isFirstLaunch = true;

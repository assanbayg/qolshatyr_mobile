import 'package:fast_contacts/fast_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

// it turn out to be unnecessary
// i wasted so many hours working on permission with several packages and i'm so fricking frustrated
// 😭😭😭😭
// i will delete it on the next commit but let keep it as reminder of my stupidity

class ContactService {
  Future<List<Contact>> getContacts() async {
    bool isGranted = await Permission.contacts.status.isGranted;
    if (!isGranted) {
      await Permission.contacts.request();
      isGranted = await Permission.contacts.status.isGranted;
    }

    if (isGranted) {
      try {
        List<Contact> contacts = await FastContacts.getAllContacts();
        print('Contacts: $contacts');
        return contacts;
      } catch (e) {
        print('Error fetching contacts: $e');
        return [];
      }
    } else {
      print('Contacts permission not granted');
      return [];
    }
  }
}

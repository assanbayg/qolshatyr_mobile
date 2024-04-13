import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';

class ContactService {
  List<Contact> addContact(Contact? contact, List<Contact>? contacts) {
    if (contact != null) {
      return [...?contacts, contact];
    }
    return contacts ?? [];
  }
}

import 'package:flutter/material.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact>? contacts;
  List<Contact> selectedContacts = [];

  @override
  void initState() {
    // ContactsServiceImpl().getContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: FutureBuilder(
          future: getContacts(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(child: Text('No contacts available'));
            }
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Contact contact = snapshot.data![index];
                  return ListTile(
                    title: Text(contact.displayName),
                    subtitle: Column(
                      children: [
                        Text(contact.phones.isNotEmpty
                            ? contact.phones[0].toString()
                            : 'No phone number'),
                        Text(contact.emails.isNotEmpty
                            ? contact.emails[0].toString()
                            : 'No email')
                      ],
                    ),
                  );
                });
          }),
    );
  }

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

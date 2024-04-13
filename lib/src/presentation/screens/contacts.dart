import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final FlutterContactPicker _contactPicker = FlutterContactPicker();
  List<Contact>? _contacts;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElevatedButton(
            child: Text("Single"),
            onPressed: () async {
              Contact? contact = await _contactPicker.selectContact();
              setState(() {
                _contacts = [...?_contacts, contact!];
              });
            },
          ),
          if (_contacts != null)
            ..._contacts!.map(
              (e) => Text(e.toString()),
            )
        ],
      ),
    );
  }
}

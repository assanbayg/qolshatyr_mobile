// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/contacts/providers/contact_provider.dart';

class ContactFloatingActionButton extends ConsumerWidget {
  const ContactFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FlutterNativeContactPicker contactPicker = FlutterNativeContactPicker();

    void pickContact() async {
      final Contact? contact = await contactPicker.selectContact();
      if (contact != null) {
        ref.read(contactListProvider.notifier).addContact(
              contact.fullName!,
              contact.phoneNumbers![0],
              '',
            );
      }
    }

    return FloatingActionButton(
      onPressed: pickContact,
      child: const Icon(Icons.person_add),
    );
  }
}

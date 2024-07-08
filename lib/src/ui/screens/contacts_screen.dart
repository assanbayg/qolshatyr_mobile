// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/src/models/contact.dart';
import 'package:qolshatyr_mobile/src/providers/auth_provider.dart';
import 'package:qolshatyr_mobile/src/providers/contact_provider.dart';
import 'package:qolshatyr_mobile/src/ui/widgets/contact_card.dart';

class ContactsScreen extends ConsumerWidget {
  static const routeName = '/base/contacts';
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final contacts = ref.watch(contactListProvider);

    void fetchContacts() async {
      final authService = ref.read(fireBaseAuthProvider);
      final firestoreService = ref.read(firestoreServiceProvider);
      List<Contact> fetchedContacts = await firestoreService
          .getEmergencyContacts(authService.currentUser!.uid);
      ref.read(contactListProvider.notifier).updateContacts(fetchedContacts);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(Icons.account_circle_rounded, size: 80),
                Expanded(
                  child: Text(
                    localization.emergencyContactsCall,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: fetchContacts,
          child: Text(localization.syncContacts),
        ),
        if (contacts.isEmpty)
          Center(
            child: Text(localization.noEmergencyContacts),
          ),
        if (contacts.isNotEmpty)
          ...contacts.map(
            (contact) => ContactCard(contact: contact),
          ),
      ],
    );
  }
}

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/contacts/contact_model.dart';
import 'package:qolshatyr_mobile/features/contacts/ui/widgets/contact_card.dart';

class ContactsList extends StatelessWidget {
  final List<Contact> contacts;
  final AppLocalizations localization;
  const ContactsList({
    super.key,
    required this.contacts,
    required this.localization,
  });

  @override
  Widget build(BuildContext context) {
    if (contacts.isEmpty) {
      return Text(localization.noEmergencyContacts);
    }

    return SizedBox(
      height: 500,
      child: SingleChildScrollView(
        child: Column(
          children:
              contacts.map((contact) => ContactCard(contact: contact)).toList(),
        ),
      ),
    );
  }
}

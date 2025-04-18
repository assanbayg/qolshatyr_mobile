// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/contacts/providers/contact_provider.dart';
import 'package:qolshatyr_mobile/features/contacts/ui/widgets/contacts_list.dart';
import 'package:qolshatyr_mobile/features/contacts/ui/widgets/emergency_contacts_header.dart';

class ContactsScreen extends ConsumerWidget {
  static const routeName = '/base/contacts';
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final contactsList = ref.watch(contactListProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          EmergencyContactsHeader(localization: localization),
          ContactsList(contacts: contactsList, localization: localization),
        ],
      ),
    );
  }
}

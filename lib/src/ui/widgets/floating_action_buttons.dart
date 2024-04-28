import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:qolshatyr_mobile/src/models/contact.dart' as contact_model;
import 'package:qolshatyr_mobile/src/providers/contact_provider.dart';
import 'package:qolshatyr_mobile/src/services/contact_service.dart';
import 'package:qolshatyr_mobile/src/services/dialog_service.dart';
import 'package:qolshatyr_mobile/src/services/location_service.dart';

class ContactFloatingActionButton extends ConsumerWidget {
  const ContactFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FlutterContactPicker contactPicker = FlutterContactPicker();

    void pickContact() async {
      final Contact? contact = await contactPicker.selectContact();
      String id = ContactService().generateRandomId();

      if (contact != null) {
        ref.read(contactListProvider.notifier).addContact(
              contact_model.Contact(
                id,
                contact.fullName!,
                contact.phoneNumbers![0],
              ),
            );
      }
    }

    return FloatingActionButton(
      onPressed: pickContact,
      child: const Icon(Icons.person_add),
    );
  }
}

class CreateTripFloatingActionButton extends StatelessWidget {
  const CreateTripFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final LocationService locationService = LocationService();
        final DialogService dialogService = DialogService();
        final LocationData? currentPosition =
            await locationService.getCurrentLocation();

        dialogService.showBottomSheet(context, currentPosition!);
      },
      child: const Icon(Icons.local_taxi_rounded),
    );
  }
}

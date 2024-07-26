// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/services/check_in_service.dart';
import 'package:qolshatyr_mobile/features/common/ui/widgets/image_picker_widget.dart';
import 'package:qolshatyr_mobile/features/trip/trip_provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheckInScreen extends ConsumerWidget {
  static const routeName = 'check-in';
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final CheckInService checkInService = CheckInService();
    final trip = ref.read(tripProvider.notifier);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "Start time ${trip.latestTrip.startTime.hour}:${trip.latestTrip.startTime.minute}"),
                Text(
                    "End time ${DateTime.now().hour}:${DateTime.now().minute}"),
              ],
            ),
            const Divider(),
            const ImagePickerWidget(),
            const Divider(),
            Text("Locatation A - ${trip.latestTrip.startLocation}"),
            Text("Locatation B - ${trip.latestTrip.endLocation}"),
            ElevatedButton(
              onPressed: () {
                checkInService.saveCheckIn();
              },
              child: Text(localization.checkIn),
            )
          ],
        ),
      ),
    );
  }
}

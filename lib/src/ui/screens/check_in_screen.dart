// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/src/providers/trip_provider.dart';
import 'package:qolshatyr_mobile/src/ui/widgets/image_picker_widget.dart';

class CheckInScreen extends ConsumerWidget {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          ],
        ),
      ),
    );
  }
}

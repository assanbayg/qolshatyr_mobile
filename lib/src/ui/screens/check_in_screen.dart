// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

// Project imports:
import 'package:qolshatyr_mobile/src/providers/trip_provider.dart';

class CheckInScreen extends ConsumerWidget {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trip = ref.read(tripProvider.notifier);
    LocationData? locationData = LocationData.fromMap({});

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            const Placeholder(fallbackHeight: 200),
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
            ElevatedButton(
                onPressed: () {}, child: const Text("Video recording")),
            const Placeholder(fallbackHeight: 250),
            const Divider(),
            Text("Locatation A - ${trip.latestTrip.startLocation}"),
            Text("Locatation B - ${currentPositionProvider.toString()}"),
          ],
        ),
      ),
    );
  }
}

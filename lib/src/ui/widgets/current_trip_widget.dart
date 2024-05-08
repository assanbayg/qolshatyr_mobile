import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qolshatyr_mobile/src/providers/timer_provider.dart';
import 'package:qolshatyr_mobile/src/providers/trip_provider.dart';
import 'package:qolshatyr_mobile/src/services/notification_service.dart';

class CurrentTripWidget extends ConsumerWidget {
  const CurrentTripWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final int timer = ref.watch(timerProvider);
    final int checkinTimer = ref.watch(checkInProvider);
    final trip = ref.read(tripProvider.notifier);

    if (timer == 0 && trip.isOngoing) {
      NotificationService.showSimpleNotification(
          title: 'Trip has ended',
          body: 'Confirm you are safe',
          payload: 'payload');
      trip.updateStatus(false);
    }

    if (checkinTimer == 0 && trip.isOngoing) {
      NotificationService.showSimpleNotification(
          title: 'Check In', body: 'Update your status', payload: 'test');
      // TODO: use custom duration
      // or at least update it for the release
      ref
          .read(checkInProvider.notifier)
          .startTimer(const Duration(seconds: 60));
    }

    String formatTime(int time) {
      return time.toString().padLeft(2, '0');
    }

    int hours = timer ~/ 3600;
    int remainingSeconds = timer % 3600;
    int minutes = remainingSeconds ~/ 60;
    int seconds = remainingSeconds % 60;

    return Center(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: size.width * 2 / 3,
                height: size.width * 2 / 3,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey,
                  value: timer.toDouble() / 3600,
                  strokeWidth: 10.0,
                ),
              ),
            ),
            Center(
              child: Text(
                "${formatTime(hours)}h ${formatTime(minutes)}m ${formatTime(seconds)}s",
                style: const TextStyle(fontSize: 24.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

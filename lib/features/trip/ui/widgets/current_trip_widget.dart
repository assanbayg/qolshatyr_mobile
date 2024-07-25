// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/providers/timer_provider.dart';
import 'package:qolshatyr_mobile/features/common/services/notification_service.dart';
import 'package:qolshatyr_mobile/features/common/utils/shared_preferences.dart';
import 'package:qolshatyr_mobile/features/trip/trip_provider.dart';

class CurrentTripWidget extends ConsumerWidget {
  const CurrentTripWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final int timer = ref.watch(currentTripTimerProvider);
    final int checkinTimer = ref.watch(checkInProvider);
    final trip = ref.read(tripProvider.notifier);

    if (timer == 0 && trip.isOngoing) {
      NotificationService.showReminderNotification(
        title: 'Trip has ended',
        body: 'Confirm you are safe',
        payload: 'payload',
      );
      trip.updateStatus(false);
    }

    if (checkinTimer == 0 && trip.isOngoing) {
      NotificationService.showReminderNotification(
          title: 'Check In', body: 'Update your status', payload: 'test');
      ref.read(checkInProvider.notifier).startTimer(Duration(
          seconds: SharedPreferencesManager.getCheckInReminderDuration()!));
    }

    String formatTime(int time) {
      return time.toString().padLeft(2, '0');
    }

    int hours = timer ~/ 3600;
    int remainingSeconds = timer % 3600;
    int minutes = remainingSeconds ~/ 60;
    int seconds = remainingSeconds % 60;

    final initialDuration = trip.estimateDuration.inSeconds;
    final progress =
        initialDuration == 0 ? 0 : timer.toDouble() / initialDuration;

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
                  value: 1 - progress.toDouble(),
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

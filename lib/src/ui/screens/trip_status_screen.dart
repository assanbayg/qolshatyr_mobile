// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/src/providers/contact_provider.dart';
import 'package:qolshatyr_mobile/src/providers/timer_provider.dart';
import 'package:qolshatyr_mobile/src/providers/trip_provider.dart';
import 'package:qolshatyr_mobile/src/providers/voice_recognition_provider.dart';
import 'package:qolshatyr_mobile/src/services/call_service.dart';
import 'package:qolshatyr_mobile/src/services/notification_service.dart';
import 'package:qolshatyr_mobile/src/ui/widgets/current_trip_widget.dart';

class TripStatusScreen extends StatefulWidget {
  static const routeName = '/base/sos/';
  const TripStatusScreen({super.key});

  @override
  State<TripStatusScreen> createState() => _TripStatusScreenState();
}

class _TripStatusScreenState extends State<TripStatusScreen> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Consumer(builder: (context, ref, child) {
      final voiceService = ref.watch(voiceServiceProvider);
      final trip = ref.watch(tripProvider.notifier);
      final tripNotifier = ref.watch(tripProvider.notifier);
      final timerNotifier = ref.watch(currentTripTimerProvider.notifier);
      final checkinNotifier = ref.watch(checkInProvider.notifier);
      final contacts = ref.read(contactListProvider);

      return Center(
        child: trip.isOngoing
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CurrentTripWidget(),
                  TextButton(
                    onPressed: voiceService.toggleListening,
                    child: Text(localization.toggleListening),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        tripNotifier.updateStatus(false);
                        NotificationService.showReminderNotification(
                            title: "Trip Ended",
                            body: "Verify you are safe!",
                            payload: 'endTrip');
                        timerNotifier.stopTimer();
                        checkinNotifier.stopTimer();
                      },
                      child: Text(localization.endTheTrip)),
                  ElevatedButton(
                    onPressed: () async {
                      if (contacts.isNotEmpty) {
                        CallService.callNumber(contacts.first.phoneNumber);
                        NotificationService.showCallResultNotification();
                      }
                    },
                    child: Text(localization.sendSosMessage),
                  ),
                ],
              )
            : const Text(
                "No active trip",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
      );
    });
  }
}

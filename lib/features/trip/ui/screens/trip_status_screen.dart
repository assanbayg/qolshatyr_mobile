// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/providers/timer_provider.dart';
import 'package:qolshatyr_mobile/features/common/services/check_in_service.dart';
import 'package:qolshatyr_mobile/features/common/services/notification_service.dart';
import 'package:qolshatyr_mobile/features/common/ui/screens/check_in_screen.dart';
import 'package:qolshatyr_mobile/features/contacts/contact_provider.dart';
import 'package:qolshatyr_mobile/features/trip/trip_provider.dart';
import 'package:qolshatyr_mobile/features/trip/ui/widgets/current_trip_widget.dart';
import 'package:qolshatyr_mobile/features/voice_recognition/voice_recognition_provider.dart';

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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const CheckInScreen()));
                      },
                      child: Text(localization.endTheTrip)),
                  ElevatedButton(
                    onPressed: () async {
                      if (contacts.isNotEmpty) {
                        final CheckInService checkInService = CheckInService();
                        checkInService.triggerSos();
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

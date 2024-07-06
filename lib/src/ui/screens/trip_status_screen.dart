// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

// Project imports:
import 'package:qolshatyr_mobile/src/providers/contact_provider.dart';
import 'package:qolshatyr_mobile/src/providers/trip_provider.dart';
import 'package:qolshatyr_mobile/src/providers/voice_recognition_provider.dart';
import 'package:qolshatyr_mobile/src/services/call_service.dart';
import 'package:qolshatyr_mobile/src/services/notification_service.dart';
import 'package:qolshatyr_mobile/src/services/twilio_service.dart';
import 'package:qolshatyr_mobile/src/ui/widgets/current_trip_widget.dart';
import 'package:qolshatyr_mobile/src/utils/shared_preferences.dart';

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
      final contacts = ref.read(contactListProvider);
      final trip = ref.read(tripProvider.notifier);
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CurrentTripWidget(),
            TextButton(
              onPressed: voiceService.toggleListening,
              child: Text(localization.toggleListening),
            ),
            // future TODO: stop trip when button is pressed
            ElevatedButton(
                onPressed: () {
                  trip.updateStatus(false);
                  NotificationService.showSimpleNotification(
                      title: "Trip Ended",
                      body: "Verify you are safe!",
                      payload: 'endTrip');
                },
                child: Text(localization.endTheTrip)),
            ElevatedButton(
              onPressed: () async {
                LocationData location =
                    await SharedPreferencesManager.getLastLocation()
                        as LocationData;
                if (contacts.isNotEmpty) {
                  // TwilioService.sendMessage(contacts.first.phoneNumber,
                  //     'Help me lat:${location.latitude} long:${location.longitude}!');
                  CallService.callNumber(contacts.first.phoneNumber);
                  NotificationService.showCallResultNotification();
                }
              },
              child: Text(localization.sendSosMessage),
            ),
            ElevatedButton(
              onPressed: () => _showDialog(context),
              child: Text(localization.setNewCheckInTimer),
            ),
          ],
        ),
      );
    });
  }

  void _showDialog(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration:
                InputDecoration(hintText: localization.enterTimeInMinutes),
          ),
          actions: [
            TextButton(
              child: Text(localization.update),
              onPressed: () {
                int? number = int.tryParse(controller.text);
                if (number != null) {
                  SharedPreferencesManager.updateTimerDuration(number);
                }
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(localization.endTheTrip),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

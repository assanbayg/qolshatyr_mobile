import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qolshatyr_mobile/src/providers/timer_provider.dart';
import 'package:qolshatyr_mobile/src/providers/trip_provider.dart';
import 'package:qolshatyr_mobile/src/providers/voice_recognition_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DialogService {
  Future<void> showAuthExceptionsDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(_).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Shows the dialog when MapScreen is initialized
  // Opens Modular Sheet to create a new Trip instance
  Future<void> showInitialDialog(
    BuildContext context,
    LocationData userCurrentPosition,
  ) async {
    final localization = AppLocalizations.of(context)!;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localization.sendLocation),
          content: Text(localization.initialDialogMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                showCreateTrip(context, userCurrentPosition);
              },
              child: Text(localization.next),
            ),
          ],
        );
      },
    );
  }

  void showCreateTrip(BuildContext context, LocationData userCurrentPosition) {
    TimeOfDay? estimatedArrivalTime;
    final localization = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // Wrap with Riverpod Consumer to access neccessary providers
        return Consumer(
          builder: (context, ref, _) {
            final tripNotifier = ref.read(tripProvider.notifier);
            final timerNotifier = ref.read(timerProvider.notifier);
            final checkinNotifier = ref.read(checkInProvider.notifier);
            final voiceService = ref.watch(voiceServiceProvider);

            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        localization.enterDestination,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16.0),
                      TextButton(
                        onPressed: () async {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext builder) {
                              return SizedBox(
                                //change to SizedBox???
                                height: MediaQuery.of(context).size.height / 3,
                                child: CupertinoTimerPicker(
                                  initialTimerDuration: estimatedArrivalTime !=
                                          null
                                      ? Duration(
                                          hours: estimatedArrivalTime!.hour,
                                          minutes: estimatedArrivalTime!.minute)
                                      : Duration.zero,
                                  mode: CupertinoTimerPickerMode.hm,
                                  onTimerDurationChanged:
                                      (Duration newDuration) {
                                    setState(() {
                                      estimatedArrivalTime = TimeOfDay(
                                        hour: newDuration.inHours,
                                        minute:
                                            newDuration.inMinutes.remainder(60),
                                      );
                                    });
                                  },
                                ),
                              );
                            },
                          );
                        },
                        child: Text(
                          estimatedArrivalTime == null
                              ? '00:00'
                              : estimatedArrivalTime!.format(context),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final LocationData startLocation =
                              LocationData.fromMap({
                            'latitude': userCurrentPosition.latitude,
                            'longitude': userCurrentPosition.longitude,
                          });
                          final Duration estimateDuration = Duration(
                            hours: estimatedArrivalTime!.hour,
                            minutes: estimatedArrivalTime!.minute,
                          );
                          // Creates a trip and starts timer before arrival
                          // Starts listening sound to hear phrase calling for help
                          tripNotifier.addTrip(startLocation, estimateDuration);
                          timerNotifier.startTimer(estimateDuration);
                          checkinNotifier
                              .startTimer(const Duration(minutes: 15));
                          voiceService.toggleListening();
                          Navigator.pop(context);
                        },
                        child: Text(localization.startTrip),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

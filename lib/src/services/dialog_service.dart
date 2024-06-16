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
    Duration? estimatedArrivalDuration;
    final localization = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(localization.enterDestination,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16.0),
                      Text(localization.pickAnyPoint),
                      TextButton(
                        onPressed: () async {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext builder) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height / 3,
                                child: CupertinoTimerPicker(
                                  initialTimerDuration:
                                      estimatedArrivalDuration ?? Duration.zero,
                                  mode: CupertinoTimerPickerMode.hm,
                                  onTimerDurationChanged:
                                      (Duration newDuration) {
                                    setState(() {
                                      estimatedArrivalDuration = newDuration;
                                    });
                                  },
                                ),
                              );
                            },
                          );
                        },
                        child: Text(
                          estimatedArrivalDuration == null
                              ? '00:00:00'
                              : formatDuration(estimatedArrivalDuration!),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (estimatedArrivalDuration != null) {
                            final LocationData startLocation =
                                LocationData.fromMap({
                              'latitude': userCurrentPosition.latitude,
                              'longitude': userCurrentPosition.longitude,
                            });
                            tripNotifier.addTrip(
                                startLocation, estimatedArrivalDuration!);
                            timerNotifier.startTimer(estimatedArrivalDuration!);
                            checkinNotifier
                                .startTimer(const Duration(minutes: 15));
                            voiceService.toggleListening();
                            Navigator.pop(context);
                          }
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

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
}

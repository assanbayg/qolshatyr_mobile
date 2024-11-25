// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/providers/timer_provider.dart';
import 'package:qolshatyr_mobile/features/common/services/camera_service.dart';
import 'package:qolshatyr_mobile/features/common/utils/shared_preferences.dart';
import 'package:qolshatyr_mobile/features/trip/trip_provider.dart';
import 'package:qolshatyr_mobile/features/voice_recognition/voice_recognition_provider.dart';

class TripDialog {
  final CameraService _cameraService = CameraService();

  void showCreateTrip(BuildContext context) {
    Duration? estimatedArrivalDuration;
    final localization = AppLocalizations.of(context)!;

    Future<LocationData?> getLastLocation() async {
      return await SharedPreferencesManager.getLastLocation();
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Consumer(
          builder: (context, ref, _) {
            final tripNotifier = ref.read(tripProvider.notifier);
            final timerNotifier = ref.read(currentTripTimerProvider.notifier);
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
                            final LocationData? startLocation =
                                await getLastLocation();

                            tripNotifier.addTrip(
                                startLocation!, estimatedArrivalDuration!);
                            tripNotifier.updateStatus(true);
                            timerNotifier.startTimer(estimatedArrivalDuration!);
                            checkinNotifier.startTimer(Duration(
                                seconds: SharedPreferencesManager
                                    .checkInReminderDuration!));
                            voiceService.toggleListening();
                            await _cameraService.startVideoRecording();

                            if (context.mounted) {
                              Navigator.pop(context);
                            }
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

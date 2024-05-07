import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qolshatyr_mobile/src/providers/timer_provider.dart';
import 'package:qolshatyr_mobile/src/providers/trip_provider.dart';
import 'package:qolshatyr_mobile/src/providers/voice_recognition_provider.dart';

class DialogService {
  // Shows the dialog with error message when it occurs
  Future<void> showAuthExceptionsDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(_).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // Shows the dialog when MapScreen is initialized
  // Opens Modular Sheet to create a new Trip instance
  Future<void> showInitialDialog(
    BuildContext context,
    LocationData userCurrentPosition,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Send your location to your close ones'),
          content: const Text('This is the initial dialog.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                showCreateTrip(context, userCurrentPosition);
              },
              child: const Text('Next'),
            ),
          ],
        );
      },
    );
  }

  void showCreateTrip(BuildContext context, LocationData userCurrentPosition) {
    TimeOfDay? estimatedArrivalTime;

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
                      const Text(
                        'Enter your destination address and estimated arrival time',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16.0),
                      TextButton(
                        onPressed: () async {
                          // Choose duration of Trip
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (picked != null) {
                            setState(() => estimatedArrivalTime = picked);
                          }
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
                          // TODO: use custom checkin timer duration
                          // Creates a trip and starts timer before arrival
                          // Starts listening sound to hear phrase calling for help
                          tripNotifier.addTrip(startLocation, estimateDuration);
                          timerNotifier.startTimer(estimateDuration);
                          checkinNotifier.startTimer(Duration(seconds: 10));
                          voiceService.toggleListening();
                          Navigator.pop(context);
                        },
                        child: const Text('Start a trip'),
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

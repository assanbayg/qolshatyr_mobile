import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qolshatyr_mobile/src/providers/timer_provider.dart';
import 'package:qolshatyr_mobile/src/providers/trip_provider.dart';

class DialogService {
  Future<void> showAuthExceptionsDialog(
      BuildContext context, String title, String message) async {
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

  Future<void> showInitialDialog(
      BuildContext context, LocationData currentPosition) async {
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
                DialogService dialogService = DialogService();
                dialogService.showCreateTrip(context, currentPosition);
              },
              child: const Text('Next'),
            ),
          ],
        );
      },
    );
  }

  void showCreateTrip(BuildContext context, LocationData currentPosition) {
    TimeOfDay? estimatedArrivalTime;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Consumer(
          builder: (context, ref, _) {
            final tripNotifier = ref.read(tripProvider.notifier);
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
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              estimatedArrivalTime = picked;
                            });
                          }
                        },
                        child: Text(
                          estimatedArrivalTime == null
                              ? '00:00'
                              : estimatedArrivalTime!.format(context),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final LocationData startLocation =
                              LocationData.fromMap({
                            'latitude': currentPosition.latitude,
                            'longitude': currentPosition.longitude,
                          });
                          final Duration estimateDuration = Duration(
                            hours: estimatedArrivalTime!.hour,
                            minutes: estimatedArrivalTime!.minute,
                          );
                          tripNotifier.addTrip(startLocation, estimateDuration);
                          ref
                              .read(timerProvider.notifier)
                              .startTimer(estimateDuration);
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

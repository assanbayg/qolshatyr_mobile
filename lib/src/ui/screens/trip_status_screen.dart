import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qolshatyr_mobile/src/providers/contact_provider.dart';
import 'package:qolshatyr_mobile/src/services/call_service.dart';
import 'package:qolshatyr_mobile/src/ui/widgets/current_trip_widget.dart';
import 'package:qolshatyr_mobile/src/providers/voice_recognition_provider.dart';

class TripStatusScreen extends StatefulWidget {
  static const routeName = '/base/sos/';
  const TripStatusScreen({super.key});

  @override
  State<TripStatusScreen> createState() => _TripStatusScreenState();
}

class _TripStatusScreenState extends State<TripStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final voiceService = ref.watch(voiceServiceProvider);
      final contacts = ref.read(contactListProvider);

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CurrentTripWidget(),
            TextButton(
              onPressed: voiceService.toggleListening,
              child: const Text('Toggle Listening'),
            ),
            // TODO: stop trip when button is pressed
            ElevatedButton(
              onPressed: () {
                CallService.callNumber(contacts[0].phoneNumber);
              },
              child: const Text('Send SOS message'),
            ),
          ],
        ),
      );
    });
  }
}

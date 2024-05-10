import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qolshatyr_mobile/src/providers/contact_provider.dart';
import 'package:qolshatyr_mobile/src/services/call_service.dart';
import 'package:qolshatyr_mobile/src/ui/widgets/current_trip_widget.dart';
import 'package:qolshatyr_mobile/src/providers/voice_recognition_provider.dart';
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
            // future TODO: stop trip when button is pressed
            ElevatedButton(
              onPressed: () {
                CallService.callNumber(contacts[0].phoneNumber);
              },
              child: const Text('Send SOS message'),
            ),
            ElevatedButton(
              onPressed: () => _showDialog(context),
              child: const Text('Set new check in timer'),
            ),
          ],
        ),
      );
    });
  }

  void _showDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration:
                const InputDecoration(hintText: "Enter a time in minutes"),
          ),
          actions: [
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                int? number = int.tryParse(controller.text);
                if (number != null) {
                  SharedPreferencesManager.updateTimerDuration(number);
                }
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qolshatyr_mobile/src/services/notifi_service.dart';
import 'package:qolshatyr_mobile/src/services/sms_sender.dart';
import 'package:qolshatyr_mobile/src/ui/widgets/current_trip_widget.dart';
import 'package:qolshatyr_mobile/src/providers/voice_recognition_provider.dart';
import 'package:qolshatyr_mobile/src/services/voice_recognition_service.dart';
import 'package:qolshatyr_mobile/src/ui/widgets/voice_recognition_widgets.dart';

class TripStatusScreen extends StatefulWidget {
  static const routeName = '/base/sos/';
  const TripStatusScreen({super.key});

  @override
  State<TripStatusScreen> createState() => _TripStatusScreenState();
}

class _TripStatusScreenState extends State<TripStatusScreen> {
  // TODO: create service for emergency calls and messaging
  String phoneNumber = '77771730178';
  Future<void> _makeEmergencyCall() async {
    NotificationService.showSimpleNotification(
        title: 'title', body: 'body', payload: 'test');
    SmsSender.sendSms(phoneNumber,
        'IF you received this message, then code is working and pls tell this to Gauhar');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final VoiceRecognitionService voiceService =
          ref.watch(voiceServiceProvider);

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CurrentTripWidget(),
            Text('Recognized Text: ${voiceService.recognizedText}'),
            Text(
              voiceService.isListening.toString(),
              style: const TextStyle(fontSize: 20),
            ),
            ListeningButton(
                isListening: voiceService.isListening,
                onPressed: voiceService.toggleListening),
            // TODO: stop trip when button is pressed
            ElevatedButton(
              onPressed: _makeEmergencyCall,
              child: const Text('Send SOS message'),
            ),
          ],
        ),
      );
    });
  }
}

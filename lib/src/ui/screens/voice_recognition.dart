import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qolshatyr_mobile/src/providers/voice_recognition_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qolshatyr_mobile/src/services/voice_recognition_service.dart';
import 'package:qolshatyr_mobile/src/ui/widgets/voice_recognition_widgets.dart';

class VoiceRecognitionScreen extends StatefulWidget {
  static const routeName = '/base/sos/';
  const VoiceRecognitionScreen({super.key});

  @override
  State<VoiceRecognitionScreen> createState() => _VoiceRecognitionScreenState();
}

class _VoiceRecognitionScreenState extends State<VoiceRecognitionScreen> {
  // TODO: create service for emergency calls and messaging
  Future<void> _makeEmergencyCall() async {
    final Uri url = Uri(
        scheme: 'https',
        host: 'dart.dev',
        path: 'guides/libraries/library-tour',
        fragment: 'numbers');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
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
            Text('Recognized Text: ${voiceService.recognizedText}'),
            const SizedBox(height: 10),
            ListeningButton(
              isListening: voiceService.isListening,
              onPressed: voiceService.toggleListening,
            ),
          ],
        ),
      );
    });
  }
}

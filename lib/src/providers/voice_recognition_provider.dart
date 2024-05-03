import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qolshatyr_mobile/src/services/voice_recognition_service.dart';

final voiceServiceProvider =
    Provider<VoiceRecognitionService>((ref) => VoiceRecognitionService());

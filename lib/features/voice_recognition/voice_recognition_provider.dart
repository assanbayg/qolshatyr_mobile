// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/voice_recognition/voice_recognition_service.dart';

final voiceServiceProvider =
    Provider<VoiceRecognitionService>((ref) => VoiceRecognitionService());

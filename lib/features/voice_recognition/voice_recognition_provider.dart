// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/utils/shared_preferences.dart'; // Import for SharedPreferencesManager
import 'package:qolshatyr_mobile/features/voice_recognition/voice_recognition_service.dart';

final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
    return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<String> {
    LanguageNotifier() : super('en') {
        _loadLanguage();
    }

    Future<void> _loadLanguage() async {
        final savedLanguage = await SharedPreferencesManager.getSavedLanguage();
        if (savedLanguage != null) {
            state = savedLanguage; // Set the language state from SharedPreferences
        }
    }

    Future<void> setLanguage(String newLanguage) async {
        state = newLanguage; // Update state
        await SharedPreferencesManager.saveLanguage(newLanguage); // Save to SharedPreferences
    }
}

final voiceServiceProvider =
    Provider<VoiceRecognitionService>((ref) => VoiceRecognitionService());

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:qolshatyr_mobile/src/app.dart';
import 'package:qolshatyr_mobile/firebase_options.dart';
import 'package:qolshatyr_mobile/src/services/notification_service.dart';
import 'package:qolshatyr_mobile/src/utils/shared_preferences.dart';

void main() async {
  // Ensure that neccessary services are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Lock device orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await SharedPreferencesManager.init();
  NotificationService.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Wrap QolshatyrApp to read Riverpod providers
  runApp(const ProviderScope(child: QolshatyrApp()));
}

// TODO: don't require to sync contacts all the time
// so i kinda need to store the locally???
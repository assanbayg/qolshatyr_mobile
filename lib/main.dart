// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/app.dart';
import 'package:qolshatyr_mobile/features/common/services/notification_service.dart';
import 'package:qolshatyr_mobile/features/common/utils/shared_preferences.dart';
import 'package:qolshatyr_mobile/firebase_options.dart';

void main() async {
  // Ensure that neccessary sesrvices are initialized
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SharedPreferencesManager.init();
  NotificationService.init();

  // Lock device orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Wrap QolshatyrApp to read Riverpod providers
  runApp(const ProviderScope(child: QolshatyrApp()));
}

// TODO: don't require to sync contacts all the time
// so i kinda need to store the locally???

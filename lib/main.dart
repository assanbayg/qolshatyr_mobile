import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:qolshatyr_mobile/src/app.dart';
import 'package:qolshatyr_mobile/firebase_options.dart';
import 'package:qolshatyr_mobile/src/services/notification_service.dart';

void main() async {
  // Ensure that neccessary services are initialized
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Wrap QolshatyrApp to read Riverpod providers
  runApp(const ProviderScope(child: QolshatyrApp()));
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:qolshatyr_mobile/src/app.dart';
import 'package:qolshatyr_mobile/firebase_options.dart';
import 'package:qolshatyr_mobile/src/services/notifi_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: QolshatyrApp()));
}

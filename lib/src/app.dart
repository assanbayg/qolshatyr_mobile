import 'package:flutter/material.dart';

import 'package:qolshatyr_mobile/src/themes.dart';
import 'package:qolshatyr_mobile/src/presentation/screens/navigation.dart';
import 'package:qolshatyr_mobile/src/presentation/screens/auth.dart';

class QolshatyrApp extends StatelessWidget {
  const QolshatyrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qolshatyr',
      theme: lightTheme,
      darkTheme: darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const NavigationScreen(),
        '/auth': (context) => const AuthScreen(),
      },
    );
  }
}

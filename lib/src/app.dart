import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qolshatyr_mobile/src/themes.dart';
import 'package:qolshatyr_mobile/src/ui/screens/base.dart';
import 'package:qolshatyr_mobile/src/ui/screens/auth/login.dart';
import 'package:qolshatyr_mobile/src/providers/auth_provider.dart';
import 'package:qolshatyr_mobile/src/ui/screens/auth/auth_checker.dart';
import 'package:qolshatyr_mobile/src/ui/screens/auth/error.dart';
import 'package:qolshatyr_mobile/src/ui/screens/auth/loading.dart';

class QolshatyrApp extends ConsumerWidget {
  const QolshatyrApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialize = ref.watch(firebaseinitializerProvider);

    return MaterialApp(
      title: 'Qolshatyr',
      theme: lightTheme,
      darkTheme: darkTheme,
      // initialRoute: '/auth',
      home: initialize.when(
          data: (data) {
            return const AuthChecker();
          },
          loading: () => const LoadingScreen(),
          error: (e, stackTrace) => ErrorScreen(e, stackTrace)),
      routes: {
        '/base': (context) => const BaseScreen(),
        '/auth': (context) => const LoginScreen(),
      },
    );
  }
}

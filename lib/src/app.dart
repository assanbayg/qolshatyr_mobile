// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/src/providers/auth_provider.dart';
import 'package:qolshatyr_mobile/src/themes.dart';
import 'package:qolshatyr_mobile/src/ui/screens/auth/auth_checker.dart';
import 'package:qolshatyr_mobile/src/ui/screens/auth/error.dart';
import 'package:qolshatyr_mobile/src/ui/screens/auth/loading.dart';
import 'package:qolshatyr_mobile/src/ui/screens/auth/login.dart';
import 'package:qolshatyr_mobile/src/ui/screens/base_screen.dart';

class QolshatyrApp extends ConsumerWidget {
  const QolshatyrApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialize = ref.watch(firebaseinitializerProvider);
    return MaterialApp(
      title: 'Qolshatyr',
      // Declrare Localization Delegates
      localizationsDelegates: const [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('kk'),
        Locale('ru'),
      ],
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      // When app is initialized it checks whether user signed in AuthChecker
      // AuthChecker is responsible for that so don't do anything with it
      home: initialize.when(
        data: (data) {
          return const AuthChecker();
        },
        loading: () => const LoadingScreen(),
        error: (e, stackTrace) => ErrorScreen(e, stackTrace),
      ),

      // Routes in the app. Maybe add other ones but now I navigate using BottomNavigationBar
      routes: {
        '/base': (context) => const BaseScreen(),
        '/auth': (context) => const LoginScreen(),
      },
    );
  }
}

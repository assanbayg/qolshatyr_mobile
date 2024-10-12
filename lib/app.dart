// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/auth/auth_provider.dart';
import 'package:qolshatyr_mobile/features/auth/ui/screens/auth_checker_screen.dart';
import 'package:qolshatyr_mobile/features/auth/ui/screens/error.dart';
import 'package:qolshatyr_mobile/features/auth/ui/screens/loading.dart';
import 'package:qolshatyr_mobile/features/auth/ui/screens/login.dart';
import 'package:qolshatyr_mobile/features/common/ui/screens/base_screen.dart';
import 'package:qolshatyr_mobile/features/common/ui/screens/check_in_screen.dart';
import 'package:qolshatyr_mobile/features/common/ui/screens/faq_screen.dart';
import 'package:qolshatyr_mobile/features/common/ui/screens/map_screen.dart';
import 'package:qolshatyr_mobile/features/common/ui/screens/settings_screen.dart';
import 'package:qolshatyr_mobile/features/common/ui/screens/tech_support_screen.dart';
import 'package:qolshatyr_mobile/features/contacts/ui/contacts_screen.dart';
import 'package:qolshatyr_mobile/features/trip/ui/screens/trip_status_screen.dart';
import 'package:qolshatyr_mobile/features/trip/ui/screens/trips_history_screen.dart';
import 'package:qolshatyr_mobile/features/trip/ui/screens/trips_local_history_screen.dart';
import 'package:qolshatyr_mobile/themes.dart';

class QolshatyrApp extends ConsumerWidget {
  const QolshatyrApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialize = ref.watch(firebaseinitializerProvider);
    return MaterialApp(
      title: 'Qolshatyr',
      // Declrare Localization Delegates
      localizationsDelegates: const [
        AppLocalizations.delegate,
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

      routes: {
        '/auth': (context) => const LoginScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/tech-support': (context) => const TechSupportScreen(),
        // '/trips-history': (context) => TripsHistoryScreen(),
        '/trips-local-history': (context) => const TripsLocalHistoryScreen(),
        '/check-in': (context) => const CheckInScreen(),
        '/faq': (context) => const FAQScreen(),
        '/base': (context) => const BaseScreen(),
        '/base/map': (context) => const MapScreen(),
        '/base/trip-status': (context) => const TripStatusScreen(),
        '/base/contacts': (context) => const ContactsScreen(),
      },
    );
  }
}

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/auth/auth_provider.dart';
import 'package:qolshatyr_mobile/features/auth/ui/screens/auth_checker_screen.dart';
import 'package:qolshatyr_mobile/features/common/ui/screens/faq_screen.dart';
import 'package:qolshatyr_mobile/features/common/ui/screens/settings_screen.dart';
import 'package:qolshatyr_mobile/features/common/ui/screens/tech_support_screen.dart';
import 'package:qolshatyr_mobile/features/common/ui/screens/user_guide_screen.dart';
import 'package:qolshatyr_mobile/features/trip/ui/screens/trips_local_history_screen.dart';
import 'package:qolshatyr_mobile/themes.dart';

class MyDrawer extends ConsumerWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.read(firebaseAuthProvider);
    final localization = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: const BorderRadius.horizontal(right: Radius.circular(30)),
      child: Drawer(
        child: Container(
          height: double.maxFinite,
          width: MediaQuery.of(context).size.width * 2 / 3,
          decoration: const BoxDecoration(),
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: darkPrimaryColor),
                accountName:
                    Text(authService.currentUser!.displayName ?? 'User'),
                accountEmail: Text(authService.currentUser!.email ?? ''),
              ),
              // ListTile(
              //   title: Text(localization.userTrips),
              //   leading: const Icon(Icons.local_taxi_rounded),
              //   onTap: () {
              //     Navigator.of(context).pushNamed(TripsHistoryScreen.routeName);
              //   },
              // ),
              ListTile(
                title: const Text('Trips History'),
                leading: const Icon(Icons.local_taxi_rounded),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(TripsLocalHistoryScreen.routeName);
                },
              ),
              ListTile(
                title: const Text('FAQ'),
                leading: const Icon(Icons.info_rounded),
                onTap: () async {
                  Navigator.of(context).pushNamed(FAQScreen.routeName);
                },
              ),
              ListTile(
                title: const Text('User Guide'),
                leading: const Icon(Icons.book_rounded),
                onTap: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserGuideScreen()),
                    // builder: (context) => const OnboardingScreen()),
                  );
                },
              ),
              ListTile(
                title: const Text('Tech support'),
                leading: const Icon(Icons.flag_rounded),
                onTap: () async {
                  Navigator.of(context).pushNamed(TechSupportScreen.routeName);
                },
              ),
              ListTile(
                title: Text(localization.settings),
                leading: const Icon(Icons.settings_rounded),
                onTap: () {
                  Navigator.of(context).pushNamed(SettingsScreen.routeName);
                },
              ),
              ListTile(
                title: Text(localization.signOut),
                leading: const Icon(Icons.logout_rounded),
                onTap: () async {
                  await authService.signOut();

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool('isFirstLaunch', true);

                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AuthChecker()),
                    );
                  }
                },
              ),
              ListTile(
                title: const Text('DEVS ONLY'),
                leading: const Icon(Icons.bug_report),
                onTap: () {
                  Navigator.of(context).pushNamed('/dev');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

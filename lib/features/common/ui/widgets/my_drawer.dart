// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/auth/auth_provider.dart';
import 'package:qolshatyr_mobile/features/common/ui/screens/settings_screen.dart';
import 'package:qolshatyr_mobile/features/trip/ui/screens/trips_history_screen.dart';

class MyDrawer extends ConsumerWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.read(fireBaseAuthProvider);
    final localization = AppLocalizations.of(context)!;

    return Drawer(
      child: Container(
        height: double.maxFinite,
        width: MediaQuery.of(context).size.width * 2 / 3,
        decoration: const BoxDecoration(),
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(authService.currentUser!.displayName ?? 'User'),
              accountEmail: Text(authService.currentUser!.email ?? ''),
            ),
            ListTile(
              title: Text(localization.signOut),
              leading: const Icon(Icons.logout_rounded),
              onTap: () async {
                await authService.signOut();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
            ListTile(
              title: Text(localization.userTrips),
              leading: const Icon(Icons.local_taxi_rounded),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return TripsHistoryScreen();
                }));
              },
            ),
            ListTile(
              title: Text(localization.settings),
              leading: const Icon(Icons.settings_rounded),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const SettingsScreen();
                }));
              },
            )
          ],
        ),
      ),
    );
  }
}

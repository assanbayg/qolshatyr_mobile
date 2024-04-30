import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qolshatyr_mobile/src/providers/auth_provider.dart';
import 'package:qolshatyr_mobile/src/ui/screens/trips_history.dart';

class MyDrawer extends ConsumerWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.read(fireBaseAuthProvider);

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
              title: const Text('Sign Out'),
              leading: const Icon(Icons.logout_rounded),
              onTap: () async {
                await authService.signOut();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
            ListTile(
              title: const Text('User Trips'),
              leading: const Icon(Icons.local_taxi_rounded),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return TripsHistoryScreen();
                }));
              },
            ),
          ],
        ),
      ),
    );
  }
}

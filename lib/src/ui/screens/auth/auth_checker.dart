// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/src/providers/auth_provider.dart';
import 'package:qolshatyr_mobile/src/ui/screens/auth/error.dart';
import 'package:qolshatyr_mobile/src/ui/screens/auth/loading.dart';
import 'package:qolshatyr_mobile/src/ui/screens/auth/login.dart';
import 'package:qolshatyr_mobile/src/ui/screens/base_screen.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return authState.when(
        data: (data) {
          return data != null ? const BaseScreen() : const LoginScreen();
        },
        loading: () => const LoadingScreen(),
        error: (e, trace) => ErrorScreen(e, trace));
  }
}

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/auth/auth_provider.dart';
import 'package:qolshatyr_mobile/features/auth/ui/screens/error.dart';
import 'package:qolshatyr_mobile/features/auth/ui/screens/loading.dart';
import 'package:qolshatyr_mobile/features/auth/ui/screens/login.dart';
import 'package:qolshatyr_mobile/features/common/ui/screens/splash_screen.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return authState.when(
        data: (data) {
          return data != null ? const SplashScreen() : const LoginScreen();
        },
        loading: () => const LoadingScreen(),
        error: (e, trace) => ErrorScreen(e, trace));
  }
}

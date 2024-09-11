// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/ui/screens/base_screen.dart';
import 'package:qolshatyr_mobile/features/common/ui/widgets/daily_guide.dart';
import 'package:qolshatyr_mobile/features/common/ui/widgets/emergency_guide.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'How to use our app?',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
            Text(
              'Daily usage',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const DailyGuide(),
            const SizedBox(height: 20),
            Text(
              'Emergency usage',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const EmergencyGuide(),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool('isFirstLaunch', false);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const BaseScreen()),
                  );
                },
                child: const Text('Got it!'))
          ],
        ),
      ),
    );
  }
}

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:qolshatyr_mobile/features/common/ui/widgets/privacy_policy_modal_window.dart';

// Project imports:
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
                onPressed: () {
                  showPrivacyPolicyDialog(context);
                },
                child: const Text('Got it!'))
          ],
        ),
      ),
    );
  }
}

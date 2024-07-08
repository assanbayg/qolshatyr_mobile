// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:qolshatyr_mobile/src/utils/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          Text(
            localization.updateCheckInDuration,
            // Update Check-In timer duration (show reminder notification N minutes before trip ends)
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          CupertinoTimerPicker(
            initialTimerDuration: Duration(
                seconds:
                    SharedPreferencesManager.getCheckInReminderDuration()!),
            mode: CupertinoTimerPickerMode.ms,
            onTimerDurationChanged: (Duration newDuration) {
              final int durationInSeconds =
                  newDuration.inSeconds + newDuration.inMinutes * 60;
              SharedPreferencesManager.updateCheckInReminderDuration(
                  durationInSeconds);
            },
          ),
        ],
      ),
    );
  }
}

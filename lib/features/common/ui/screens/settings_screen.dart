// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/utils/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = "/settings";
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              localization.updateCheckInDuration,
              // Update Check-In timer duration (show reminder notification N minutes before trip ends)
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            CupertinoTimerPicker(
              initialTimerDuration: Duration(
                  seconds: SharedPreferencesManager.checkInReminderDuration!),
              mode: CupertinoTimerPickerMode.ms,
              onTimerDurationChanged: (Duration newDuration) {
                final int durationInSeconds =
                    newDuration.inSeconds + newDuration.inMinutes * 60;
                SharedPreferencesManager.updateCheckInReminderDuration(
                    durationInSeconds);
              },
            ),
            const Divider(thickness: 2),
            Text(
            localization.updateKeyPhrase,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            TextField(
              decoration:
                  InputDecoration(hintText: SharedPreferencesManager.sosPhrase),
              onChanged: (value) =>
                  SharedPreferencesManager.updateSosPhrase(value),
            )
          ],
        ),
      ),
    );
  }
}

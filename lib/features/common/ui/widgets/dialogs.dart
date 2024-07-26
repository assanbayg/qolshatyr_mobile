// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/trip/trip_dialog.dart';

Future<void> showAuthExceptionsDialog(
  BuildContext context,
  String title,
  String message,
) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}

Future<void> showInitialDialog(BuildContext context) async {
  final localization = AppLocalizations.of(context)!;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(localization.sendLocation),
        content: Text(localization.initialDialogMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              TripDialog().showCreateTrip(context);
            },
            child: Text(localization.next),
          ),
        ],
      );
    },
  );
}

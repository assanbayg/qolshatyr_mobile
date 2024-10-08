// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/data/privacy_policy_text.dart';
import 'package:qolshatyr_mobile/features/common/ui/screens/base_screen.dart';

Future<void> showPrivacyPolicyDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(privacyPolicyText),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final Uri url =
                  Uri.parse('https://qolshatyr.netlify.app/privacy-policy');
              if (!await launchUrl(url)) {
                throw Exception('Could not launch $url');
              }
            },
            child: const Text('Read policy'),
          ),
          TextButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isFirstLaunch', false);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const BaseScreen()),
              );
            },
            child: const Text('Accept'),
          ),
        ],
      );
    },
  );
}

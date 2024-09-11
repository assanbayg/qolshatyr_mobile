// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:carousel_slider/carousel_slider.dart';

// Project imports:
import 'package:qolshatyr_mobile/themes.dart';

const List<Map<String, String>> dailyGuide = [
  {
    'title': '1. Set Up Your Profile',
    'description':
        'Add your basic information and emergency contacts. This ensures that if anything happens, your trusted contacts will be notified immediately.'
  },
  {
    'title': '2. Activate Check-In Timers',
    'description':
        'Before going on a walk or commute, activate the check-in timer. Set the expected time of your journey. Qolshatyr will remind you to check in, and if you don’t, it will automatically alert your contacts.'
  },
  {
    'title': '3. Review Route History',
    'description':
        'Review your route history to track your movements or share them with friends and family for added peace of mind.'
  },
  {
    'title': '4. Use Voice Activation for Safety',
    'description':
        'Test the voice activation feature during non-emergency times to ensure it works properly. This way, you’ll feel confident using it when necessary.'
  },
  {
    'title': '5. Keep Your Contacts Updated',
    'description':
        'Regularly update your emergency contacts. Make sure they know they are listed and are aware of potential notifications.'
  },
];

class DailyGuide extends StatelessWidget {
  const DailyGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        autoPlayInterval: const Duration(seconds: 10),
      ),
      items: dailyGuide.map((guide) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: darkPrimaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(guide['title']!,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                  const SizedBox(height: 10),
                  Text(
                    guide['description']!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

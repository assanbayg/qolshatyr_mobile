// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:carousel_slider/carousel_slider.dart';

const List<Map<String, String>> emergencyGuide = [
  {
    'title': '1. Feeling Unsafe',
    'description':
        'Quietly activate the check-in system to alert your contacts of your location. Move toward safe and well-lit areas or find a public place.'
  },
  {
    'title': '2. Being Followed or Watched',
    'description':
        'Use the voice-activated SOS feature discreetly to send your location. Keep moving toward populated areas.'
  },
  {
    'title': '3. Immediate Danger',
    'description':
        'Trigger the voice activation to call for help. Speak naturally to avoid suspicion and look for escape routes.'
  },
  {
    'title': '4. If You Can’t Check In',
    'description':
        'If you miss a check-in, Qolshatyr will notify your contacts and send them your last known location and journey route.'
  },
  {
    'title': '5. Post-Emergency',
    'description':
        'After the situation is resolved, review route history and messages sent during the emergency. Share information with authorities or contacts.'
  },
];

class EmergencyGuide extends StatelessWidget {
  const EmergencyGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        autoPlayInterval: const Duration(seconds: 10),
      ),
      items: emergencyGuide.map((guide) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    guide['title']!,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    guide['description']!,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
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

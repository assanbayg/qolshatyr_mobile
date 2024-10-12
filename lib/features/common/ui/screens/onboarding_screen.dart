// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/ui/widgets/privacy_policy_modal_window.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _features = [
    {
      'description': 'Specify your route and check in on time',
      'image': 'assets/feature1.png', // Add your image paths
    },
    {
      'description': 'Personally select and set your emergency contacts',
      'image': 'assets/feature2.png',
    },
    // {
    //   'description': 'Get real-time notifications and support',
    //   'image': 'assets/feature3.png',
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(141, 210, 143, 1),
              Color.fromRGBO(83, 137, 129, 1),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _features.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
                // Check if the last page is reached
                if (index == _features.length - 1) {
                  Future.delayed(const Duration(seconds: 10), () {
                    if (!mounted) return;
                    showPrivacyPolicyDialog(context);
                    if (mounted) {
                      Future.delayed(const Duration(seconds: 40), () {});
                    }
                  });
                }
              },
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      _features[index]['image']!,
                      height: 300,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 70,
                      ),
                      child: Text(
                        _features[index]['description']!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: 18),
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _features.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: _currentIndex == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? Colors.white
                          : const Color.fromARGB(255, 60, 79, 77),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              right: 30,
              child: GestureDetector(
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isFirstLaunch', false);

                  if (!mounted) return;

                  Navigator.pushReplacementNamed(context, '/base');
                },
                child: Text(
                  'SKIP',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color.fromARGB(255, 60, 79, 77),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

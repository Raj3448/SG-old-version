import 'package:flutter/material.dart';
import 'package:silver_genie/feature/onboarding/screens/page1.dart';
import 'package:silver_genie/feature/onboarding/screens/page2.dart';
import 'package:silver_genie/feature/onboarding/screens/page3.dart';
import 'package:silver_genie/feature/onboarding/screens/page4.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(
              height: 700,
              width: MediaQuery.sizeOf(context).width,
              child: PageView(
                controller: pageController,
                children: const [
                  Page1(),
                  Page2(),
                  Page3(),
                  Page4(),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear,
                );
              },
              child: const Center(child: Text('Next')),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // TODO(Amanjot): Fix this
                // pageController.jumpTo();
              },
              child: const Text('Skip'),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

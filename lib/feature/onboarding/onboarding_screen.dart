// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/feature/login-signup/login_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();

  Timer? _timer;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 6),
      (Timer timer) {
        if (_currentPageIndex < 2) {
          _currentPageIndex++;
        } else {
          _currentPageIndex = 0;
        }
        pageController.animateToPage(
          _currentPageIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const _Button(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 490,
            child: PageView(
              controller: pageController,
              children: const [
                _PageView(
                  imgPath: 'assets/onboarding/img1.png',
                  desc:
                      'Revolutionizing elder care in India, empowering seniors to lead independent lives.',
                ),
                _PageView(
                  imgPath: 'assets/onboarding/img2.png',
                  desc:
                      'Tailored healthcare concierge experiences, connecting seniors to doctors, counselors, nutritionists, and more.',
                ),
                _PageView(
                  imgPath: 'assets/onboarding/img3.png',
                  desc:
                      'Instant access to emergency services, ensuring peace of mind for your loved ones.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SmoothPageIndicator(
            controller: pageController,
            count: 3,
            effect: const ExpandingDotsEffect(
              activeDotColor: AppColors.primary,
              dotColor: AppColors.grayscale300,
              dotHeight: 8,
              dotWidth: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _PageView extends StatelessWidget {
  const _PageView({required this.imgPath, required this.desc});

  final String imgPath;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          imgPath,
          scale: 0.85,
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            desc,
            textAlign: TextAlign.center,
            style: AppTextStyle.bodyLargeMedium
                .copyWith(color: AppColors.grayscale800),
          ),
        ),
      ],
    );
  }
}

class _Button extends StatelessWidget {
  const _Button();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            ontap: () {
              // TODO(Aman): Change it to go_router
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            title: 'Get Started',
            showIcon: false,
            iconPath: AppIcons.add,
            size: ButtonSize.normal,
            type: ButtonType.primary,
            expanded: true,
          ),
        ],
      ),
    );
  }
}

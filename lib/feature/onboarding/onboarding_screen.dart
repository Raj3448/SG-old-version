// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/feature/onboarding/store/onboarding_store.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();
  final store = GetIt.I<OnboardingStore>();

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
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.8,
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
        Container(
          height: MediaQuery.sizeOf(context).height * 0.65,
          decoration: const BoxDecoration(
            color: AppColors.secondary,
          ),
          child: Image.asset(
            imgPath,
            scale: 0.85,
          ),
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
    final store = GetIt.I<OnboardingStore>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            ontap: () {
              store.setOnboardingStatus(false);
            },
            title: 'Get Started'.tr(),
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
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/fonts.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/active_plan.dart';
import 'package:silver_genie/core/widgets/app_bar.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/coach_contact.dart';
import 'package:silver_genie/feature/members/screens/epr_phr_view_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Appbar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(Dimension.d4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Family Members health info',
                  style: AppTextStyle.bodyXLSemiBold,
                ),
                const SizedBox(
                  height: Dimension.d4,
                ),
                Row(
                  children: [
                    SelectableAvatar(
                      imgPath: '',
                      maxRadius: 44,
                      isSelected: true,
                      ontap: () {
                        ActivePlanComponent(
                            name: 'Varun Nair',
                            onTap: () {
                              Navigator.push(
                                context,
                                // ignore: inference_failure_on_instance_creation
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const EPRPHRViewScreen(),
                                ),
                              );
                            });
                      },
                    ),
                    const SizedBox(
                      width: Dimension.d4,
                    ),
                    SelectableAvatar(
                        imgPath: '',
                        maxRadius: 44,
                        isSelected: false,
                        ontap: () {})
                  ],
                ),
                const SizedBox(
                  height: Dimension.d4,
                ),
                const SizedBox(
                  height: Dimension.d4,
                ),
                const CoachContact(imgpath: '', name: 'Suma Latha'),
                Text(
                  'Book services',
                  style: AppTextStyle.bodyXLSemiBold
                      .copyWith(color: AppColors.grayscale900, height: 2.6),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BookServiceButton(
                      iconImagePath: 'assets/icon/volunteer_activism.png',
                      buttonName: 'Health Care',
                      onTap: () {},
                    ),
                    BookServiceButton(
                      iconImagePath: 'assets/icon/home_health.png',
                      buttonName: 'Home Care',
                      onTap: () {},
                    ),
                    BookServiceButton(
                      iconImagePath: 'assets/icon/prescriptions.png',
                      buttonName: 'Convenience',
                      onTap: () {},
                    ),
                    BookServiceButton(
                      iconImagePath: 'assets/icon/ambulance.png',
                      buttonName: 'Emergency',
                      onTap: () {
                        context
                            .pushNamed(RoutesConstants.emergencyServiceScreen);
                      },
                    ),
                  ],
                ),
                Text(
                  'About Us',
                  style: AppTextStyle.bodyXLSemiBold
                      .copyWith(color: AppColors.grayscale900, height: 2.6),
                ),
                Text(
                  'SilverGenie: Your trusted senior healthcare platform. We empower seniors for independent living, leveraging technology for real-time monitoring and improved health outcomes.',
                  style: AppTextStyle.bodyLargeMedium.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: AppColors.grayscale700),
                ),
                Text(
                  'What we offer',
                  style: AppTextStyle.bodyXLSemiBold.copyWith(
                    color: AppColors.grayscale900,
                    height: 2.4,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: Dimension.d1,
                ),
                SizedBox(
                  height: 240,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(right: 200),
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                        4,
                        (index) => const _HomeScreenOfferCard(
                              offerTitle: 'SG Workforce',
                              content1: 'Trained critical care nursing staff',
                              content2:
                                  'Trained nursing staff or attendants for senior citizens',
                            )),
                  ),
                ),
                const SizedBox(
                  height: Dimension.d4,
                ),
                Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 4,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: AppColors.primary,
                      dotColor: AppColors.grayscale300,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),
                ),
                Text(
                  'Newsletter',
                  style: AppTextStyle.bodyXLSemiBold.copyWith(
                    color: AppColors.grayscale900,
                    height: 2.6,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Stay ahead with exclusive updates, offers, and content. Subscribe now for the latest news delivered straight to your inbox.',
                  style: AppTextStyle.bodyLargeMedium.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      height: 1.4,
                      color: AppColors.grayscale700),
                ),
                const SizedBox(
                  height: Dimension.d3,
                ),
                SizedBox(
                  height: 52,
                  child: TextFormField(
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                        fillColor: Colors.white24,
                        filled: true,
                        border: InputBorder.none,
                        hintText: 'Enter Your Email',
                        hintStyle: AppTextStyle.bodyMediumMedium.copyWith(
                            color: AppColors.grayscale600,
                            fontSize: 16,
                            height: 1.46,
                            fontWeight: FontWeight.w400,
                            fontFamily: FontFamily.inter),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2, color: AppColors.secondary),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2, color: AppColors.primary),
                            borderRadius: BorderRadius.circular(10))),
                    onFieldSubmitted: (value) {},
                  ),
                ),
                const SizedBox(
                  height: Dimension.d4,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        fixedSize:
                            const MaterialStatePropertyAll(Size(360, 48)),
                        backgroundColor: null,
                        shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                    width: 2, color: AppColors.primary)))),
                    onPressed: () {},
                    child: Text(
                      'Subscribe',
                      style: AppTextStyle.bodyXLSemiBold.copyWith(
                        color: AppColors.primary,
                        height: 2.4,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    )),
                const SizedBox(
                  height: Dimension.d10,
                ),
              ],
            ),
          ),
        ));
  }
}

class BookServiceButton extends StatelessWidget {
  const BookServiceButton(
      {required this.iconImagePath,
      required this.buttonName,
      required this.onTap,
      super.key});

  final String iconImagePath;
  final String buttonName;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
                color: AppColors.secondary,
                border: Border.all(width: 2, color: AppColors.grayscale300),
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(iconImagePath),
          ),
          Text(
            buttonName,
            style: AppTextStyle.bodySmallMedium.copyWith(
                color: AppColors.grayscale700,
                fontWeight: FontWeight.w500,
                height: 2.6),
          )
        ],
      ),
    );
  }
}

class _HomeScreenOfferCard extends StatelessWidget {
  const _HomeScreenOfferCard(
      {required this.offerTitle,
      required this.content1,
      required this.content2,
      super.key});

  final String offerTitle;
  final String content1;
  final String content2;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 236,
      width: 235,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          color: AppColors.secondary,
          border: Border.all(width: 2, color: AppColors.grayscale300),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            offerTitle,
            style: AppTextStyle.bodyXLSemiBold.copyWith(
              color: AppColors.grayscale900,
              height: 2.4,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 7),
                child: Icon(
                  AppIcons.check,
                  size: 12,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(
                width: Dimension.d3,
              ),
              Expanded(
                child: Text(
                  content1,
                  style: AppTextStyle.bodyMediumMedium
                      .copyWith(color: AppColors.grayscale700, height: 1.7),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: Dimension.d2,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 7),
                child: Icon(
                  AppIcons.check,
                  size: 12,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(
                width: Dimension.d3,
              ),
              Expanded(
                child: Text(
                  content2,
                  style: AppTextStyle.bodyMediumMedium
                      .copyWith(color: AppColors.grayscale700, height: 1.7),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

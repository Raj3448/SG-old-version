import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/fonts.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/active_plan.dart';
import 'package:silver_genie/core/widgets/app_bar.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/coach_contact.dart';
import 'package:silver_genie/feature/members/screens/epr_phr_view_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselController _carouselController = CarouselController();
  int _currentIndex = 0;
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
                      buttonName: 'HealthCare',
                      onTap: () {},
                    ),
                    BookServiceButton(
                      iconImagePath: 'assets/icon/home_health.png',
                      buttonName: 'HomeCare',
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
                  height: Dimension.d2,
                ),
                CarouselSlider(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                      height: 236,
                      aspectRatio: 2,
                      viewportFraction: 0.68,
                      enableInfiniteScroll: false,
                      pauseAutoPlayOnTouch: true,
                      onScrolled: (double? offset) {},
                      onPageChanged: (index, reason) {
                        print(index);
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      pageSnapping: false,
                      padEnds: false),
                  items: List.generate(
                      4,
                      (index) => const HomeScreenOfferCard(
                          offerTitle: 'SG Workforce',
                          content1: 'Trained critical care nursing staff',
                          content2:
                              'Trained nursing staff or attendants for senior citizens')),
                ),
                const SizedBox(
                  height: Dimension.d4,
                ),
                Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      4,
                      (index) => AnimatedContainer(
                            height: 8,
                            width: _currentIndex == index ? 15 : 8,
                            margin: const EdgeInsets.all(2),
                            duration: const Duration(seconds: 1),
                            decoration: BoxDecoration(
                                color: _currentIndex == index
                                    ? AppColors.primary
                                    : AppColors.grayscale400,
                                borderRadius: BorderRadius.circular(3)),
                          )),
                )),
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
                    // focusNode: _searchFocusNode,
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
                    onFieldSubmitted: (value) {
                      //_searchFocusNode.unfocus();
                    },
                  ),
                ),
                const SizedBox(
                  height: Dimension.d4,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      alignment: Alignment(0, 0),
                      height: 48,
                      width: 360,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(width: 2, color: AppColors.primary)),
                      child: Text(
                        'Subscribe',
                        style: AppTextStyle.bodyXLSemiBold.copyWith(
                          color: AppColors.primary,
                          height: 2.4,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
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

class HomeScreenOfferCard extends StatelessWidget {
  const HomeScreenOfferCard(
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
      margin: const EdgeInsets.symmetric(horizontal: 10),
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
              Image.asset(
                'assets/icon/verified.png',
                height: 30,
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
              Image.asset(
                'assets/icon/verified.png',
                height: 30,
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

// ignore_for_file: public_member_api_docs, sort_constructors_first, inference_failure_on_function_invocation
// ignore_for_file: unnecessary_null_comparison, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/active_plan.dart';
import 'package:silver_genie/core/widgets/app_bar.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/back_to_home_component.dart';
import 'package:silver_genie/core/widgets/booking_service_listile_component.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/coach_contact.dart';
import 'package:silver_genie/core/widgets/inactive_plan.dart';
import 'package:silver_genie/feature/home/store/home_store.dart';
import 'package:silver_genie/feature/home/widgets/no_member.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final PageController _offerPageController = PageController();
  final PageController _testimonialsCardController = PageController();
  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<HomeStore>();
    return Scaffold(
      appBar: const Appbar(),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Dimension.d4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Observer(
                builder: (_) {
                  return Column(
                    children: [
                      if (store.familyMembers.isEmpty)
                        const NoMember()
                      else
                        const _MemberInfo(),
                    ],
                  );
                },
              ),
              _EmergencyActivation(),
              _ActiveBookingComponent(),
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
                    onTap: () {
                      context.pushNamed(RoutesConstants.servicesCareScreen,
                          pathParameters: {'pageTitle': 'Health Care Service'});
                    },
                  ),
                  BookServiceButton(
                    iconImagePath: 'assets/icon/home_health.png',
                    buttonName: 'Home Care',
                    onTap: () {
                      context.pushNamed(RoutesConstants.servicesCareScreen,
                          pathParameters: {'pageTitle': 'Home Care Service'});
                    },
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
                      context.pushNamed(RoutesConstants.geniePage,
                          pathParameters: {
                            'pageTitle': 'Emergency Genie',
                            'defination':
                                'We understand the unpredictability of life, but that shouldn’t hinder your well-being. With our comprehensive emergency support service, we’ll ensure holistic care for you. From sickness to health, here are the promises we intend to deliver',
                            'headline':
                                'A dedicated plan in place, focused on remote health monitoring for you and your loved ones.'
                          });
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
                  height: 1.5,
                  color: AppColors.grayscale700,
                ),
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
                  controller: _offerPageController,
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    4,
                    (index) => const _HomeScreenOfferCard(
                      offerTitle: 'SG Workforce',
                      content1: 'Trained critical care nursing staff',
                      content2:
                          'Trained nursing staff or attendants for senior citizens',
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: Dimension.d4,
              ),
              Center(
                child: SmoothPageIndicator(
                  controller: _offerPageController,
                  count: 4,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: AppColors.primary,
                    dotColor: AppColors.grayscale300,
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimension.d3),
                child: CustomButton(
                  ontap: () {},
                  title: 'Know More',
                  showIcon: false,
                  iconPath: Icons.not_interested,
                  size: ButtonSize.normal,
                  type: ButtonType.secondary,
                  expanded: true,
                  iconColor: AppColors.white,
                ),
              ),
              Text(
                'Testimonials',
                style: AppTextStyle.bodyXLSemiBold.copyWith(
                  color: AppColors.grayscale900,
                  height: 2.6,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 132,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(right: 200),
                  controller: _testimonialsCardController,
                  scrollDirection: Axis.horizontal,
                  children: List.generate(3, (index) => _TestmonialsCard()),
                ),
              ),
              const SizedBox(
                height: Dimension.d3,
              ),
              Center(
                child: SmoothPageIndicator(
                  controller: _testimonialsCardController,
                  count: 3,
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
                  color: AppColors.grayscale700,
                ),
              ),
              const SizedBox(
                height: Dimension.d4,
              ),
              CustomButton(
                ontap: () {},
                title: 'Subscribe',
                showIcon: false,
                iconPath: AppIcons.add,
                size: ButtonSize.normal,
                type: ButtonType.secondary,
                expanded: true,
                iconColor: AppColors.white,
              ),
              const SizedBox(
                height: Dimension.d10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActiveBookingComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
          4,
          (index) => index == 0
              ? Text(
                  'Active bookings',
                  style: AppTextStyle.bodyXLSemiBold.copyWith(height: 2.6),
                )
              : const BookingListTileComponent()),
    );
  }
}

class _TestmonialsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132,
      margin: const EdgeInsets.only(left: Dimension.d2),
      padding: const EdgeInsets.all(Dimension.d2),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(Dimension.d2)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
              width: 220,
              child: Text(
                  'The service was amazing and support from care couch is great overall.')),
          SizedBox(
            width: 220,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Avatar.fromSize(
                  imgPath: '',
                  size: AvatarSize.size12,
                ),
                const SizedBox(
                  width: Dimension.d2,
                ),
                Text(
                  'Varun Nair',
                  style: AppTextStyle.bodyMediumMedium.copyWith(
                      color: AppColors.grayscale800,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _EmergencyActivation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: Dimension.d2),
      padding: const EdgeInsets.symmetric(
        horizontal: Dimension.d2,
        vertical: Dimension.d3,
      ),
      height: 170,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grayscale300),
        borderRadius: BorderRadius.circular(Dimension.d2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emergency',
            style: AppTextStyle.bodyXLMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.grayscale900,
            ),
          ),
          Text(
            'When the button is pressed, all emergency services will be activated.',
            style: AppTextStyle.bodyMediumMedium
                .copyWith(color: AppColors.grayscale900),
          ),
          SizedBox(
            height: 48,
            child: CustomButton(
              ontap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return _EmergencyActivateBottomSheet();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimension.d3),
                  ),
                  constraints: const BoxConstraints(maxHeight: 320),
                  backgroundColor: AppColors.white,
                );
              },
              title: 'Activate Emergency',
              showIcon: false,
              iconPath: Icons.not_interested,
              size: ButtonSize.large,
              type: ButtonType.activation,
              expanded: true,
              iconColor: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyActivateBottomSheet extends StatefulWidget {
  @override
  State<_EmergencyActivateBottomSheet> createState() =>
      _EmergencyActivateBottomSheetState();
}

class _EmergencyActivateBottomSheetState
    extends State<_EmergencyActivateBottomSheet> {
  bool isActivate = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimension.d4,
        vertical: Dimension.d3,
      ),
      child: isActivate
          ? const BackToHomeComponent(
              title: 'Emergency Alert Activated',
              description: 'You will get a Callback from our team very soon',
            )
          : Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Emergency',
                      style: AppTextStyle.bodyXLSemiBold.copyWith(
                        fontSize: 20,
                        color: AppColors.grayscale900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: AppTextStyle.bodyMediumMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                Text(
                  'Please select the member who require emergency assistance',
                  style: AppTextStyle.bodyMediumMedium.copyWith(
                    color: AppColors.grayscale700,
                  ),
                ),
                const SizedBox(
                  height: Dimension.d2,
                ),
                _ActivateListileComponent(
                  onPressed: () {
                    setState(() {
                      isActivate = true;
                    });
                  },
                ),
                _ActivateListileComponent(
                  onPressed: () {
                    setState(() {
                      isActivate = true;
                    });
                  },
                ),
              ],
            ),
    );
  }
}

class _ActivateListileComponent extends StatelessWidget {
  final VoidCallback onPressed;
  const _ActivateListileComponent({
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: Dimension.d2),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grayscale300),
        borderRadius: BorderRadius.circular(Dimension.d2),
      ),
      padding: const EdgeInsets.all(Dimension.d3),
      child: Row(
        children: [
          const CircleAvatar(
            maxRadius: 22,
            backgroundImage: AssetImage(
              'assets/icon/Profile.png',
            ),
          ),
          const SizedBox(
            width: Dimension.d2,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shalini Nair',
                style: AppTextStyle.bodyLargeMedium
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                'Mother',
                style: AppTextStyle.bodyMediumMedium
                    .copyWith(color: AppColors.grayscale700),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            height: 48,
            width: 120,
            child: CustomButton(
              ontap: onPressed,
              title: 'Activate',
              showIcon: false,
              iconPath: AppIcons.add,
              size: ButtonSize.normal,
              type: ButtonType.warnActivate,
              expanded: true,
              iconColor: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberInfo extends StatelessWidget {
  const _MemberInfo();

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<HomeStore>();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Family Members health info',
            style: AppTextStyle.bodyXLSemiBold,
          ),
          const SizedBox(height: Dimension.d4),
          Observer(
            builder: (_) {
              return Column(
                children: [
                  Row(
                    children: [
                      for (var i = 0; i < store.familyMembers.length; i++)
                        Row(
                          children: [
                            SelectableAvatar(
                              imgPath: store.familyMembers[i].imagePath,
                              maxRadius: 24,
                              isSelected: store.selectedIndex == i,
                              ontap: () => store.selectAvatar(i),
                            ),
                            const SizedBox(width: Dimension.d4),
                          ],
                        ),
                      SelectableAvatar(
                        imgPath: 'assets/icon/44Px.png',
                        maxRadius: 24,
                        isSelected: false,
                        ontap: () {
                          context.pushNamed(
                            RoutesConstants.addEditFamilyMemberRoute,
                            pathParameters: {'edit': 'false'},
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimension.d4),
                  if (store.selectedIndex != -1)
                    Observer(
                      builder: (_) {
                        final selectedMember =
                            store.familyMembers[store.selectedIndex];
                        return selectedMember != null
                            ? selectedMember.isActive
                                ? ActivePlanComponent(
                                    name: selectedMember.name,
                                    onTap: () {
                                      GoRouter.of(context)
                                          .push(RoutesConstants.eprPhrRoute);
                                    },
                                  )
                                : InactivePlanComponent(
                                    name: selectedMember.name,
                                  )
                            : const SizedBox();
                      },
                    ),
                  const SizedBox(height: Dimension.d4),
                  if (store.selectedIndex != -1)
                    Observer(
                      builder: (_) {
                        final selectedMember =
                            store.familyMembers[store.selectedIndex];
                        return selectedMember != null && selectedMember.isActive
                            ? const CoachContact(
                                imgpath: '',
                                name: 'Suma Latha',
                              )
                            : const SizedBox();
                      },
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class BookServiceButton extends StatelessWidget {
  const BookServiceButton({
    required this.iconImagePath,
    required this.buttonName,
    required this.onTap,
    super.key,
  });

  final String iconImagePath;
  final String buttonName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              border: Border.all(width: 2, color: AppColors.grayscale300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(iconImagePath),
          ),
          Text(
            buttonName,
            style: AppTextStyle.bodySmallMedium.copyWith(
              color: AppColors.grayscale700,
              fontWeight: FontWeight.w500,
              height: 2.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeScreenOfferCard extends StatelessWidget {
  const _HomeScreenOfferCard({
    required this.offerTitle,
    required this.content1,
    required this.content2,
  });

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
        borderRadius: BorderRadius.circular(10),
      ),
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
          ),
        ],
      ),
    );
  }
}

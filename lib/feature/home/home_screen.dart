// ignore_for_file: public_member_api_docs, sort_constructors_first, inference_failure_on_function_invocation, use_if_null_to_convert_nulls_to_bools, use_build_context_synchronously
// ignore_for_file: unnecessary_null_comparison, lines_longer_than_80_chars

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/env.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/utils/launch_dialer.dart';
import 'package:silver_genie/core/widgets/active_plan.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/back_to_home_component.dart';
import 'package:silver_genie/core/widgets/banner_network_img_component.dart';
import 'package:silver_genie/core/widgets/booking_service_listile_component.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/coach_contact.dart';
import 'package:silver_genie/core/widgets/inactive_plan.dart';
import 'package:silver_genie/core/widgets/member_creation.dart';
import 'package:silver_genie/feature/bookings/store/booking_service_store.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';
import 'package:silver_genie/feature/home/model/home_page_model.dart';
import 'package:silver_genie/feature/home/store/home_store.dart';
import 'package:silver_genie/feature/home/widgets/no_member.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';
import 'package:silver_genie/feature/notification/services/fcm_notification_manager.dart';
import 'package:silver_genie/feature/user_profile/store/user_details_store.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final MembersStore memberStore;
  late final productLStore = GetIt.I<ProductListingStore>();
  final bookingServiceStore = GetIt.I<BookingServiceStore>();
  final homestore = GetIt.I<HomeStore>();

  @override
  void initState() {
    super.initState();
    FcmNotificationManager(context).init();
    memberStore = GetIt.I<MembersStore>()..init();
    reaction((_) => memberStore.errorMessage, (loaded) {
      if (memberStore.errorMessage == null) {
        return;
      }
      memberStore.errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Observer(
              builder: (_) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimension.d4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: memberStore.isLoading
                            ? const SizedBox(
                                height: Dimension.d20,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                  ),
                                ),
                              )
                            : memberStore.familyMembers.isEmpty
                                ? NoMember(
                                    ontap: () {
                                      final user = GetIt.I<UserDetailStore>()
                                          .userDetails;
                                      final member =
                                          memberStore.memberById(user!.id);
                                      if (member != null) {
                                        context.pushNamed(
                                          RoutesConstants
                                              .addEditFamilyMemberRoute,
                                          pathParameters: {
                                            'edit': 'false',
                                            'isSelf': 'false',
                                          },
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return MemberCreation(
                                              selfOnTap: () {
                                                context.pushNamed(
                                                  RoutesConstants
                                                      .addEditFamilyMemberRoute,
                                                  pathParameters: {
                                                    'edit': 'false',
                                                    'isSelf': 'true',
                                                  },
                                                );
                                              },
                                              memberOnTap: () {
                                                context.pushNamed(
                                                  RoutesConstants
                                                      .addEditFamilyMemberRoute,
                                                  pathParameters: {
                                                    'edit': 'false',
                                                    'isSelf': 'false',
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        );
                                      }
                                    },
                                  )
                                : const _MemberInfo(),
                      ),
                      if (memberStore.members.isNotEmpty)
                        _EmergencyActivation(memberStore: memberStore),
                      if (bookingServiceStore.isAllServiceLoaded)
                        _ActiveBookingComponent(store: bookingServiceStore),
                      Text(
                        'Book services',
                        style: AppTextStyle.bodyXLSemiBold.copyWith(
                          color: AppColors.grayscale900,
                          height: 2.6,
                        ),
                      ),
                      FittedBox(
                        child: Row(
                          mainAxisAlignment:
                              MediaQuery.of(context).orientation ==
                                      Orientation.landscape
                                  ? MainAxisAlignment.spaceAround
                                  : MainAxisAlignment.spaceBetween,
                          children: [
                            BookServiceButton(
                              iconImagePath:
                                  'assets/icon/volunteer_activism.png',
                              buttonName: 'Health Care',
                              onTap: () {
                                context.pushNamed(
                                  RoutesConstants.allServicesScreen,
                                  pathParameters: {
                                    'isHealthCare': 'true',
                                    'isHomeCare': 'false',
                                    'isConvenience': 'false',
                                  },
                                );
                              },
                            ),
                            BookServiceButton(
                              iconImagePath: 'assets/icon/home_health.png',
                              buttonName: 'Home Care',
                              onTap: () {
                                context.pushNamed(
                                  RoutesConstants.allServicesScreen,
                                  pathParameters: {
                                    'isHealthCare': 'false',
                                    'isHomeCare': 'true',
                                    'isConvenience': 'false',
                                  },
                                );
                              },
                            ),
                            BookServiceButton(
                              iconImagePath: 'assets/icon/prescriptions.png',
                              buttonName: 'Wellness & Convenience',
                              onTap: () {
                                context.pushNamed(
                                  RoutesConstants.allServicesScreen,
                                  pathParameters: {
                                    'isHealthCare': 'false',
                                    'isHomeCare': 'false',
                                    'isConvenience': 'true',
                                  },
                                );
                              },
                            ),
                            BookServiceButton(
                              iconImagePath: 'assets/icon/ambulance.png',
                              buttonName: 'Emergency',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      _HomeScreenComponents(
                        homestore: homestore,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeScreenComponents extends StatelessWidget {
  const _HomeScreenComponents({required this.homestore, super.key});

  final HomeStore homestore;

  @override
  Widget build(BuildContext context) {
    if (!homestore.isHomepageDataLoaded) {
      return const SizedBox();
    }
    final componentDetailsList = homestore.isHomepageData;
    final widgetList = <Widget>[];
    for (final component in componentDetailsList) {
      if (component is AboutUsOfferModel) {
        widgetList.add(
          _AboutUsOfferComponent(
            aboutUsOfferModel: component,
          ),
        );
        continue;
      }
      if (component is BannerImageModel) {
        widgetList.add(
          GestureDetector(
            onTap: () async {
              final url = component.cta?.href;
              if (url != null && await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimension.d2),
              child: BannerImageComponent(
                imageUrl: component.bannerImage.data!.attributes.url,
              ),
            ),
          ),
        );
        continue;
      }
      if (component is TestimonialsModel) {
        widgetList.add(
          _TestmonialsComponent(
            testimonialsModel: component,
          ),
        );
        continue;
      }
      if (component is NewsletterModel) {
        widgetList.add(
          _NewsletterComponent(
            newsletterModel: component,
          ),
        );
        continue;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgetList,
    );
  }
}

class _TestmonialsComponent extends StatelessWidget {
  _TestmonialsComponent({
    required this.testimonialsModel,
  });

  final PageController _testimonialsCardController =
      PageController(viewportFraction: 0.60);
  final TestimonialsModel testimonialsModel;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          testimonialsModel.title,
          style: AppTextStyle.bodyXLSemiBold.copyWith(
            color: AppColors.grayscale900,
            height: 2.6,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        Container(
          color: AppColors.secondary,
          padding: const EdgeInsets.symmetric(horizontal: Dimension.d1),
          child: Column(
            children: [
              SizedBox(
                height: 132,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  controller: _testimonialsCardController,
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    testimonialsModel.testimonials.data.length,
                    (index) => _TestmonialsCard(
                      testifierName: testimonialsModel
                          .testimonials.data[index].attributes.testifierName,
                      content: testimonialsModel
                          .testimonials.data[index].attributes.content,
                      imgUrl: testimonialsModel.testimonials.data[index]
                          .attributes.testifierImage?.data!.attributes.url,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: Dimension.d3,
              ),
              Center(
                child: SmoothPageIndicator(
                  controller: _testimonialsCardController,
                  count: testimonialsModel.testimonials.data.length,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: AppColors.primary,
                    dotColor: AppColors.grayscale300,
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                ),
              ),
              const SizedBox(
                height: Dimension.d3,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: Dimension.d3,
        ),
      ],
    );
  }
}

class _AboutUsOfferComponent extends StatelessWidget {
  _AboutUsOfferComponent({
    required this.aboutUsOfferModel,
  });

  final AboutUsOfferModel aboutUsOfferModel;
  final PageController _offerPageController =
      PageController(viewportFraction: 0.58);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          aboutUsOfferModel.header,
          style: AppTextStyle.bodyXLSemiBold
              .copyWith(color: AppColors.grayscale900, height: 2.6),
        ),
        Text(
          aboutUsOfferModel.description,
          style: AppTextStyle.bodyLargeMedium.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            height: 1.5,
            color: AppColors.grayscale700,
          ),
        ),
        Text(
          aboutUsOfferModel.offering.header,
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
            controller: _offerPageController,
            scrollDirection: Axis.horizontal,
            children: List.generate(
              aboutUsOfferModel.offering.offers.length,
              (index) => _HomeScreenOfferCard(
                offerTitle: aboutUsOfferModel.offering.offers[index].title,
                content: List.generate(
                  aboutUsOfferModel.offering.offers[index].values.length,
                  (i) =>
                      aboutUsOfferModel.offering.offers[index].values[i].value,
                ),
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
            count: aboutUsOfferModel.offering.offers.length,
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
            ontap: () async {
              String url;
              url = aboutUsOfferModel.cta.href ??
                  aboutUsOfferModel.cta.link!.href;
              if (url != null && await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              }
            },
            title: aboutUsOfferModel.cta.label,
            showIcon: false,
            iconColor: AppColors.error,
            iconPath: Icons.not_interested,
            size: ButtonSize.normal,
            type: ButtonType.secondary,
            expanded: true,
          ),
        ),
      ],
    );
  }
}

class _ActiveBookingComponent extends StatelessWidget {
  const _ActiveBookingComponent({required this.store, super.key});

  final BookingServiceStore store;
  @override
  Widget build(BuildContext context) {
    return store.getAllActiveServiceList.isEmpty
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Active bookings',
                style: AppTextStyle.bodyXLSemiBold.copyWith(height: 2.6),
              ),
              ...List.generate(
                store.getAllActiveServiceList.length > 3
                    ? 3
                    : store.getAllActiveServiceList.length,
                (index) => BookingListTileComponent(
                  bookingServiceModel: store.getAllActiveServiceList[index],
                  bookingServiceStatus: BookingServiceStatus.active,
                ),
              ),
            ],
          );
  }
}

class _TestmonialsCard extends StatelessWidget {
  const _TestmonialsCard({
    required this.testifierName,
    required this.content,
    this.imgUrl,
    Key? key,
  }) : super(key: key);

  final String testifierName;
  final String content;
  final String? imgUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132,
      width: MediaQuery.sizeOf(context).width * 0.60,
      margin: const EdgeInsets.only(left: Dimension.d2),
      padding: const EdgeInsets.all(Dimension.d2),
      decoration: BoxDecoration(
        color: AppColors.grayscale100,
        borderRadius: BorderRadius.circular(Dimension.d2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            overflow: TextOverflow.ellipsis,
            maxLines: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Avatar.fromSize(
                imgPath: imgUrl == null ? '' : '${Env.serverUrl}${imgUrl!}',
                size: AvatarSize.size12,
              ),
              const SizedBox(
                width: Dimension.d2,
              ),
              Text(
                testifierName,
                style: AppTextStyle.bodyMediumMedium.copyWith(
                  color: AppColors.grayscale800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmergencyActivation extends StatelessWidget {
  final MembersStore memberStore;
  const _EmergencyActivation({required this.memberStore});
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
                    return SingleChildScrollView(
                      physics: MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? null
                          : const NeverScrollableScrollPhysics(),
                      child: _EmergencyActivateBottomSheet(
                          memberStore: memberStore),
                    );
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimension.d3),
                      topRight: Radius.circular(Dimension.d3),
                    ),
                  ),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? 400
                        : 320,
                  ),
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
  final MembersStore memberStore;
  const _EmergencyActivateBottomSheet({required this.memberStore});
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
                        context.pop();
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
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                      itemBuilder: (context, index) =>
                          _ActivateListileComponent(
                            memberName:
                                widget.memberStore.familyMembers[index].name,
                            relation: widget
                                .memberStore.familyMembers[index].relation,
                            onPressed: () async {
                              await launchDialer('+910000000000');
                              setState(() {
                                isActivate = true;
                              });
                            },
                            imgUrl: widget.memberStore.familyMembers[index]
                                .profileImg?.url,
                          ),
                      itemCount: widget.memberStore.familyMembers.length),
                )
              ],
            ),
    );
  }
}

class _ActivateListileComponent extends StatelessWidget {
  final VoidCallback onPressed;
  final String memberName;
  final String relation;
  final String? imgUrl;
  const _ActivateListileComponent(
      {required this.onPressed,
      required this.memberName,
      required this.imgUrl,
      required this.relation});
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
          Avatar.fromSize(imgPath: imgUrl ?? '', size: AvatarSize.size22),
          const SizedBox(
            width: Dimension.d2,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                memberName,
                style: AppTextStyle.bodyLargeMedium
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                relation,
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
    final memberStore = GetIt.I<MembersStore>();
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.fast,
                    ),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var i = 0;
                            i < memberStore.familyMembers.length;
                            i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Row(
                              children: [
                                SelectableAvatar(
                                  imgPath: memberStore
                                              .familyMembers[i].profileImg !=
                                          null
                                      ? '${Env.serverUrl}${memberStore.familyMembers[i].profileImg!.url}'
                                      : '',
                                  maxRadius: 24,
                                  isSelected: memberStore.familyMembers[i].id ==
                                      memberStore.activeMemberId,
                                  ontap: () => memberStore.selectMember(
                                    memberStore.familyMembers[i].id,
                                  ),
                                ),
                                const SizedBox(width: Dimension.d4),
                              ],
                            ),
                          ),
                        SelectableAvatar(
                          imgPath: 'assets/icon/44Px.png',
                          maxRadius: 24,
                          isSelected: false,
                          ontap: () {
                            final user = GetIt.I<UserDetailStore>().userDetails;
                            final member = memberStore.memberById(user!.id);
                            if (member != null) {
                              context.pushNamed(
                                RoutesConstants.addEditFamilyMemberRoute,
                                pathParameters: {
                                  'edit': 'false',
                                  'isSelf': 'false',
                                },
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return MemberCreation(
                                    selfOnTap: () {
                                      context.pushNamed(
                                        RoutesConstants
                                            .addEditFamilyMemberRoute,
                                        pathParameters: {
                                          'edit': 'false',
                                          'isSelf': 'true',
                                        },
                                      );
                                    },
                                    memberOnTap: () {
                                      context.pushNamed(
                                        RoutesConstants
                                            .addEditFamilyMemberRoute,
                                        pathParameters: {
                                          'edit': 'false',
                                          'isSelf': 'false',
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  if (memberStore.selectedIndex != -1)
                    Observer(
                      builder: (context) {
                        final activeMember = memberStore.activeMember;
                        if (activeMember != null &&
                            memberStore.isActive &&
                            activeMember.relation != 'Brother') {
                          return ActivePlanComponent(
                            activeMember: activeMember,
                          );
                        } else if (memberStore.isActive == false ||
                            activeMember != null ||
                            activeMember?.relation == 'Brother') {
                          return InactivePlanComponent(
                            member: activeMember!,
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  if (store.selectedIndex != -1)
                    Observer(
                      builder: (_) {
                        final selectedMember =
                            memberStore.members[memberStore.selectedIndex];
                        return selectedMember != null && memberStore.isActive
                            ? const Column(
                                children: [
                                  SizedBox(height: Dimension.d4),
                                  CoachContact(
                                    imgpath: '',
                                    name: 'Suma Latha',
                                  ),
                                ],
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
          const SizedBox(
            height: Dimension.d2,
          ),
          SizedBox(
            height: 32,
            width: 87,
            child: Text(
              buttonName,
              textAlign: TextAlign.center,
              style: AppTextStyle.bodySmallMedium.copyWith(
                color: AppColors.grayscale700,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
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
    required this.content,
  });

  final String offerTitle;
  final List<String> content;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 236,
      width: MediaQuery.sizeOf(context).width * 0.60,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        border: Border.all(width: 2, color: AppColors.grayscale300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
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
            Column(
              children: List.generate(
                content.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: Dimension.d2),
                  child: Row(
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
                          content[index],
                          style: AppTextStyle.bodyMediumMedium.copyWith(
                            color: AppColors.grayscale700,
                            height: 1.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewsletterComponent extends StatelessWidget {
  const _NewsletterComponent({required this.newsletterModel});

  final NewsletterModel newsletterModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Dimension.d6),
        Text(
          newsletterModel.title,
          style:
              AppTextStyle.bodyXLMedium.copyWith(color: AppColors.grayscale900),
        ),
        const SizedBox(height: Dimension.d3),
        Text(
          newsletterModel.description,
          style: AppTextStyle.bodyLargeMedium
              .copyWith(color: AppColors.grayscale700),
        ),
        const SizedBox(height: Dimension.d3),
        if (newsletterModel.newsletters.isNotEmpty)
          Row(
            mainAxisAlignment: newsletterModel.newsletters.length > 1
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: List.generate(
              newsletterModel.newsletters.length > 1 ? 2 : 1,
              (index) => CustomButton(
                ontap: () {
                  if (newsletterModel.newsletters[index].link.downloadLink ==
                      true) {
                    downloadAndSavePDF(
                      newsletterModel.newsletters[index].link.href,
                      '${newsletterModel.newsletters[index].link.label}',
                      context,
                    );
                  } else {
                    launchUrl(
                      Uri.parse(newsletterModel.newsletters[index].link.href),
                    );
                  }
                },
                title: newsletterModel.newsletters[index].label,
                showIcon: false,
                iconPath: AppIcons.add,
                size: ButtonSize.normal,
                type: newsletterModel.newsletters[index].theme == 'secondary'
                    ? ButtonType.secondary
                    : newsletterModel.newsletters[index].theme == 'primary'
                        ? ButtonType.primary
                        : ButtonType.tertiary,
                expanded: false,
                iconColor: AppColors.primary,
              ),
            ),
          ),
        const SizedBox(height: Dimension.d6),
      ],
    );
  }
}

Future<void> downloadAndSavePDF(
  String url,
  String fileName,
  BuildContext context,
) async {
  try {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      throw UnsupportedError('Unsupported platform');
    }

    final filePath = '${directory.path}/$fileName.pdf';

    final dio = Dio();
    final response = await dio.download(url, filePath);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'File downloaded successfully: $filePath',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error downloading file: ${response.statusCode}',
          ),
        ),
      );
    }
  } catch (e) {
    print('Error: $e');
  }
}

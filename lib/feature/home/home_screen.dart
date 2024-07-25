// ignore_for_file: public_member_api_docs, sort_constructors_first, inference_failure_on_function_invocation, use_if_null_to_convert_nulls_to_bools, use_build_context_synchronously
// ignore_for_file: unnecessary_null_comparison, lines_longer_than_80_chars

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/routes/routes.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/banner_network_img_component.dart';
import 'package:silver_genie/core/widgets/booking_service_listile_component.dart';
import 'package:silver_genie/core/widgets/member_creation.dart';
import 'package:silver_genie/feature/bookings/store/booking_service_store.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';
import 'package:silver_genie/feature/home/model/home_page_model.dart';
import 'package:silver_genie/feature/home/widgets/about_us.dart';
import 'package:silver_genie/feature/home/widgets/emergency_activation.dart';
import 'package:silver_genie/feature/home/widgets/member_info.dart';
import 'package:silver_genie/feature/home/widgets/newsletter.dart';
import 'package:silver_genie/feature/home/widgets/no_member.dart';
import 'package:silver_genie/feature/home/widgets/testimonials.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';
import 'package:silver_genie/feature/notification/services/fcm_notification_manager.dart';
import 'package:silver_genie/feature/notification/store/notification_store.dart';
import 'package:silver_genie/feature/user_profile/store/user_details_store.dart';
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

  @override
  void initState() {
    super.initState();
    FcmNotificationManager(context).init();
    memberStore = GetIt.I<MembersStore>()..init();
    memberStore.refresh();
    bookingServiceStore.initGetAllServices();
    GetIt.I<NotificationStore>().fetchNotifications();
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
                                : const MemberInfo(),
                      ),
                      if (memberStore.members.isNotEmpty &&
                          homeStore.getMasterDataModel != null)
                        EmergencyActivation(
                          memberStore: memberStore,
                          emergencyHelpline: homeStore
                              .getMasterDataModel!.masterData.emergencyHelpline,
                        ),
                      if (bookingServiceStore.isAllServiceLoaded)
                        _ActiveBookingComponent(store: bookingServiceStore),
                      Text(
                        'Book service'.tr(),
                        style: AppTextStyle.bodyXLSemiBold.copyWith(
                          color: AppColors.grayscale900,
                          height: 2.6,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          BookServiceButton(
                            iconImagePath: 'assets/icon/volunteer_activism.png',
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
                        ],
                      ),
                      const SizedBox(
                        height: Dimension.d2,
                      ),
                      const _HomeScreenComponents(),
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
  const _HomeScreenComponents();

  @override
  Widget build(BuildContext context) {
    if (!homeStore.isHomepageDataLoaded) {
      return const SizedBox();
    }
    final componentDetailsList = homeStore.isHomepageData;
    final widgetList = <Widget>[];
    for (final component in componentDetailsList) {
      if (component is AboutUsOfferModel) {
        widgetList.add(
          AboutUsOfferComponent(
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
          TestmonialsComponent(
            testimonialsModel: component,
          ),
        );
        continue;
      }
      if (component is NewsletterModel) {
        widgetList.add(
          NewsletterComponent(
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

class _ActiveBookingComponent extends StatelessWidget {
  const _ActiveBookingComponent({required this.store});

  final BookingServiceStore store;
  @override
  Widget build(BuildContext context) {
    return store.getAllActiveServiceList.isEmpty
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Active bookings'.tr(),
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
            width: 98,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              border: Border.all(width: 2, color: AppColors.grayscale300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(iconImagePath),
          ),
          const SizedBox(height: Dimension.d2),
          SizedBox(
            height: 40,
            width: 87,
            child: Text(
              buttonName,
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyMediumMedium
                  .copyWith(color: AppColors.grayscale700),
            ),
          ),
        ],
      ),
    );
  }
}

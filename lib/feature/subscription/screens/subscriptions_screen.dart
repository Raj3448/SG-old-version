// ignore_for_file: lines_longer_than_80_chars, library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/env.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/utils/calculate_age.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/customize_tabview_component.dart';
import 'package:silver_genie/core/widgets/error_state_component.dart';
import 'package:silver_genie/core/widgets/icon_title_details_component.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/core/widgets/plan_display_component.dart';
import 'package:silver_genie/feature/book_services/screens/services_screen.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';
import 'package:silver_genie/feature/user_profile/services/user_services.dart';
import 'package:silver_genie/feature/user_profile/store/user_details_store.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  _SubscriptionsScreenState createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  final subService = GetIt.I<UserDetailServices>();

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const PageAppbar(title: 'Subscriptions'),
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimension.d4)
                    .copyWith(top: Dimension.d4),
                child: FutureBuilder(
                  future: subService.fetchSubscriptions(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: LoadingWidget(showShadow: false),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: ErrorStateComponent(
                          errorType: ErrorType.somethinWentWrong,
                        ),
                      );
                    } else {
                      final eitherData = snapshot.data;

                      if (eitherData != null) {
                        return eitherData.fold(
                          (failure) {
                            return const Center(
                              child: ErrorStateComponent(
                                errorType: ErrorType.somethinWentWrong,
                              ),
                            );
                          },
                          (list) {
                            final activePlanList = list.data
                                .where(
                                  (member) =>
                                      member.subscriptionStatus == 'Active',
                                )
                                .toList();
                            final expiredPlanList = list.data
                                .where(
                                  (member) =>
                                      member.subscriptionStatus == 'Expired' &&
                                      member.paymentStatus == 'paid',
                                )
                                .toList();
                            if (list.data.isEmpty) {
                              return NoServiceFound(
                                title: 'Subscriptions',
                                ontap: () {},
                                showTitle: false,
                                isService: false,
                                name: 'subscriptions',
                              );
                            } else {
                              return Column(
                                children: [
                                  CustomizeTabviewComponent(
                                    controller: controller,
                                    tabCount: 2,
                                    widgetList: const [
                                      Tab(icon: Text('Current')),
                                      Tab(icon: Text('Previous')),
                                    ],
                                  ),
                                  const SizedBox(height: Dimension.d4),
                                  Expanded(
                                    child: TabBarView(
                                      controller: controller,
                                      children: [
                                        if (activePlanList.isEmpty)
                                          NoServiceFound(
                                            title: 'Subscriptions',
                                            ontap: () {},
                                            showTitle: false,
                                            isService: false,
                                            name: 'subscriptions',
                                          )
                                        else
                                          _SubscriptionList(
                                            members: activePlanList,
                                            isPrevious: false,
                                          ),
                                        if (expiredPlanList.isEmpty)
                                          NoServiceFound(
                                            title: 'Subscriptions',
                                            ontap: () {},
                                            showTitle: false,
                                            isService: false,
                                            name: 'subscriptions',
                                          )
                                        else
                                          _SubscriptionList(
                                            members: expiredPlanList,
                                            isPrevious: true,
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        );
                      } else {
                        return const Center(
                          child: ErrorStateComponent(
                            errorType: ErrorType.unknown,
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionList extends StatelessWidget {
  const _SubscriptionList({
    required this.members,
    required this.isPrevious,
  });
  final List<SubscriptionDetails> members;
  final bool isPrevious;

  @override
  Widget build(BuildContext context) {
    final activePlanList = members
        .where((member) => member.subscriptionStatus == 'Active')
        .toList();
    final expiredPlanList = members
        .where(
          (member) =>
              member.subscriptionStatus == 'Expired' &&
              member.paymentStatus == 'paid',
        )
        .toList();

    return ListView.builder(
      itemCount: isPrevious ? expiredPlanList.length : activePlanList.length,
      physics: const BouncingScrollPhysics(
        decelerationRate: ScrollDecelerationRate.fast,
      ),
      itemBuilder: (context, index) {
        final plan =
            isPrevious ? expiredPlanList[index] : activePlanList[index];
        return _UserDetailsComponent(
          memberDetails: plan,
          isPrevious: isPrevious,
        );
      },
    );
  }
}

class _UserDetailsComponent extends StatelessWidget {
  const _UserDetailsComponent({
    required this.memberDetails,
    required this.isPrevious,
  });

  final SubscriptionDetails memberDetails;
  final bool isPrevious;

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<UserDetailStore>();
    final memberStore = GetIt.I<MembersStore>();
    final familyMembers = memberDetails.belongsTo;
    final hasMultipleMembers = familyMembers!.length > 1;
    final interval = memberDetails.product.prices
        .where((price) => price.id == memberDetails.priceId)
        .map((price) => price.recurringInterval)
        .join(' ');
    final intervalCount = memberDetails.product.prices
        .where((price) => price.id == memberDetails.priceId)
        .map((price) => price.recurringIntervalCount)
        .join(' ');
    final members = memberStore.familyMembers;

    final hasActiveSubscription = members.any(
      (member) => member.subscriptions!.any(
        (subscription) =>
            subscription.subscriptionStatus == 'Active' &&
            subscription.paymentStatus == 'paid',
      ),
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.line),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (hasMultipleMembers)
                  Stack(
                    children: [
                      Avatar.fromSize(
                        imgPath:
                            '${Env.serverUrl}${familyMembers[0].profileImg?.url ?? ''}',
                        size: AvatarSize.size24,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Avatar.fromSize(
                          imgPath:
                              '${Env.serverUrl}${familyMembers[1].profileImg?.url ?? ''}',
                          size: AvatarSize.size24,
                        ),
                      ),
                    ],
                  )
                else
                  Avatar.fromSize(
                    imgPath:
                        '${Env.serverUrl}${memberDetails.belongsTo?.map((member) => member.profileImg?.url ?? '').join(' ')}',
                    size: AvatarSize.size24,
                  ),
                const SizedBox(width: Dimension.d3),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasMultipleMembers)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${familyMembers[0].firstName} & ${familyMembers[1].firstName}',
                            style: AppTextStyle.bodyLargeBold
                                .copyWith(color: AppColors.grayscale900),
                          ),
                          Text(
                            'Relation: ${familyMembers[0].relation} & ${familyMembers[1].relation}',
                            style: AppTextStyle.bodyMediumMedium.copyWith(
                              color: AppColors.grayscale800,
                              height: 1.5,
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${memberDetails.belongsTo?.map((member) => member.firstName).join(' ') ?? []} ${memberDetails.belongsTo?.map((member) => member.lastName).join(' ') ?? []}',
                            style: AppTextStyle.bodyLargeBold
                                .copyWith(color: AppColors.grayscale900),
                          ),
                          Text(
                            'Relation: ${memberDetails.belongsTo?.map((member) => member.relation).join(' ') ?? []}  Age: ${calculateAgeFromString(memberDetails.belongsTo?.map((member) => member.dateOfBirth).join(' ') ?? '')}',
                            style: AppTextStyle.bodyMediumMedium
                                .copyWith(color: AppColors.grayscale800),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: Dimension.d4),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconTitleDetailsComponent(
                  icon: AppIcons.elderly_person,
                  title: 'Plan',
                  details:
                      '${memberDetails.product.name} $intervalCount ${removeLastLy(interval)}',
                ),
                const SizedBox(height: Dimension.d5),
                IconTitleDetailsComponent(
                  icon: AppIcons.medical_services,
                  title: 'Status',
                  details: memberDetails.subscriptionStatus == 'Active' &&
                          memberDetails.paymentStatus == 'due'
                      ? 'Payment due'
                      : memberDetails.subscriptionStatus == 'Expired' &&
                              memberDetails.paymentStatus == 'paid'
                          ? 'Expired'
                          : 'Active',
                ),
                const SizedBox(height: Dimension.d5),
                IconTitleDetailsComponent(
                  icon: AppIcons.calendar,
                  title: isPrevious ? 'Plan ended on' : 'Plan ends on',
                  details: formatDate(memberDetails.expiresOn),
                ),
              ],
            ),
            const SizedBox(height: Dimension.d4),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    ontap: () {
                      store
                          .getSubscriptionById(id: memberDetails.id)
                          .then((result) {
                        result.fold(
                          (failure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Something went wrong!'),
                              ),
                            );
                          },
                          (success) {
                            context.pushNamed(
                              RoutesConstants.bookingDetailsScreen,
                              pathParameters: {
                                'id': '${memberDetails.id}',
                              },
                            );
                          },
                        );
                      });
                    },
                    title: 'View Details',
                    showIcon: false,
                    iconPath: AppIcons.add,
                    size: ButtonSize.small,
                    type: ButtonType.secondary,
                    expanded: true,
                    iconColor: AppColors.primary,
                  ),
                ),
                if (isPrevious) const SizedBox(width: Dimension.d2),
                if (isPrevious)
                  Expanded(
                    child: CustomButton(
                      ontap: hasActiveSubscription
                          ? null
                          : () {
                              context.pushNamed(
                                RoutesConstants.geniePage,
                                pathParameters: {
                                  'pageTitle': memberDetails.product.name,
                                  'id': '${memberDetails.product.id}',
                                  'isUpgradeable': 'false',
                                  'activeMemberId': '${memberDetails.id}',
                                },
                              );
                            },
                      title: 'Buy again',
                      showIcon: false,
                      iconPath: AppIcons.add,
                      size: ButtonSize.small,
                      type: hasActiveSubscription
                          ? ButtonType.disable
                          : ButtonType.primary,
                      expanded: true,
                      iconColor: AppColors.primary,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

int calculateAgeFromString(String dobString) {
  final dob = DateFormat('yyyy-MM-dd').parse(dobString);
  final now = DateTime.now();
  var age = now.year - dob.year;
  if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
    age--;
  }
  return age;
}

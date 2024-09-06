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
    return Scaffold(
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
                                      _SubscriptionList(
                                        members: list.data,
                                        isPrevious: false,
                                      ),
                                      _SubscriptionList(
                                        members: list.data,
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
        .where(
          (member) =>
              member.subscriptionStatus == 'Active' &&
              member.paymentStatus != 'expired',
        )
        .toList();
    final expiredPlanList = members
        .where(
          (member) =>
              member.subscriptionStatus == 'Expired' &&
              member.paymentStatus == 'paid',
        )
        .toList();

    if (isPrevious && expiredPlanList.isEmpty ||
        !isPrevious && activePlanList.isEmpty) {
      return NoServiceFound(
        title: 'Subscriptions',
        ontap: () {},
        showTitle: false,
        isService: false,
        name: 'subscriptions',
      );
    }
    return ListView.builder(
      itemCount: isPrevious ? expiredPlanList.length : activePlanList.length,
      physics: const BouncingScrollPhysics(
        decelerationRate: ScrollDecelerationRate.fast,
      ),
      itemBuilder: (context, index) {
        final plan =
            isPrevious ? expiredPlanList[index] : activePlanList[index];
        if (plan.belongsTo?.isEmpty ?? true) {
          return const SizedBox();
        }
        return _UserDetailsComponent(
          memberDetails: plan,
          isPrevious: isPrevious,
          activePlans: activePlanList,
        );
      },
    );
  }
}

class _UserDetailsComponent extends StatelessWidget {
  const _UserDetailsComponent({
    required this.memberDetails,
    required this.isPrevious,
    required this.activePlans,
  });

  final SubscriptionDetails memberDetails;
  final bool isPrevious;
  final List<SubscriptionDetails> activePlans;

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<UserDetailStore>();
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

    List<FamilyMember> extractUniqueMembers(
      List<SubscriptionDetails> subscriptionDetailList,
    ) {
      var memberList = <FamilyMember>[];
      final uniqueMembersSet = <FamilyMember>{};
      for (final subscription in subscriptionDetailList) {
        if (subscription.belongsTo != null) {
          uniqueMembersSet.addAll(subscription.belongsTo!);
        }
      }
      memberList = uniqueMembersSet.toList();
      return memberList;
    }

    var hasActiveSubscription = false;
    if (isPrevious) {
      final activePlanMemberList = extractUniqueMembers(
          activePlans.where((a) => a.paymentStatus != 'due').toList());
      hasActiveSubscription = memberDetails.belongsTo?.any((familyMember) {
            return activePlanMemberList
                .any((activeMember) => activeMember.id == familyMember.id);
          }) ??
          false;
    }
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasMultipleMembers)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${familyMembers[0].firstName} & ${familyMembers[1].firstName}',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyle.bodyLargeBold.copyWith(
                                        color: AppColors.grayscale900),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Relation: ${familyMembers[0].relation ?? ''} & ${familyMembers[1].relation ?? ''}',
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
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.bodyLargeBold
                                  .copyWith(color: AppColors.grayscale900),
                            ),
                            Text(
                              'Relation: ${memberDetails.belongsTo?.map((member) => member.relation ?? '').join(' ') ?? []}  Age: ${_calculateAgeFromString(memberDetails.belongsTo?.map((member) => member.dateOfBirth ?? '').join(' ') ?? '', null) ?? 'N/A'}',
                              style: AppTextStyle.bodyMediumMedium
                                  .copyWith(color: AppColors.grayscale800),
                            ),
                          ],
                        ),
                    ],
                  ),
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

int? _calculateAgeFromString(String dobString, String? dateFormat) {
  if (dobString.isEmpty) {
    return null;
  }
  final dob = DateFormat(dateFormat ?? 'yyyy-MM-dd').parse(dobString);
  final now = DateTime.now();
  var age = now.year - dob.year;
  if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
    age--;
  }
  return age;
}

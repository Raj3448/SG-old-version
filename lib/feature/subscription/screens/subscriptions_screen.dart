// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/customize_tabview_component.dart';
import 'package:silver_genie/core/widgets/error_state_component.dart';
import 'package:silver_genie/core/widgets/icon_title_details_component.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/book_services/screens/services_screen.dart';
import 'package:silver_genie/feature/subscription/model/subscription_member_model.dart';
import 'package:silver_genie/feature/user_profile/services/user_services.dart';

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
                padding: const EdgeInsets.all(Dimension.d4),
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
                          (failure) => const Center(
                            child: ErrorStateComponent(
                              errorType: ErrorType.somethinWentWrong,
                            ),
                          ),
                          (list) {
                            if (list.isEmpty) {
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
                                          members: list,
                                          isPrevious: false,
                                        ),
                                        _SubscriptionList(
                                          members: list,
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
  final List<SubscriptionMemberModel> members;
  final bool isPrevious;

  @override
  Widget build(BuildContext context) {
    final filteredMembers =
        members.where((member) => member.status == 'Active').toList();

    if (filteredMembers.isEmpty) {
      return NoServiceFound(
        title: 'Subscriptions',
        ontap: () {},
        showTitle: false,
        isService: false,
        name: 'subscriptions',
      );
    }

    return ListView.builder(
      itemCount: filteredMembers.length,
      physics: const BouncingScrollPhysics(
        decelerationRate: ScrollDecelerationRate.fast,
      ),
      itemBuilder: (context, index) {
        return _UserDetailsComponent(
          memberDetails: filteredMembers[index],
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

  final SubscriptionMemberModel memberDetails;
  final bool isPrevious;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
      height: 248,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.grayscale300),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Avatar.fromSize(
                  imgPath: '',
                  size: AvatarSize.size24,
                ),
                const SizedBox(width: Dimension.d3),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      memberDetails.name,
                      style: AppTextStyle.bodyLargeMedium.copyWith(
                        color: AppColors.grayscale900,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Relation: ${memberDetails.relation}  Age: ${memberDetails.age}',
                      style: AppTextStyle.bodyMediumMedium.copyWith(
                        color: AppColors.grayscale800,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: Dimension.d4),
            SizedBox(
              height: 110,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconTitleDetailsComponent(
                    icon: AppIcons.elderly_person,
                    title: 'Plan',
                    details: memberDetails.plan,
                  ),
                  IconTitleDetailsComponent(
                    icon: AppIcons.medical_services,
                    title: 'Status',
                    details: isPrevious ? 'Expired' : memberDetails.status,
                  ),
                  IconTitleDetailsComponent(
                    icon: AppIcons.calendar,
                    title: 'Plan ends on',
                    details:
                        isPrevious ? '10/2/2024' : memberDetails.planEndsDate,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    ontap: () {},
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
                      ontap: () {},
                      title: 'Buy again',
                      showIcon: false,
                      iconPath: AppIcons.add,
                      size: ButtonSize.small,
                      type: ButtonType.primary,
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

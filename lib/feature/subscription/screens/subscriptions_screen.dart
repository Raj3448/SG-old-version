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
import 'package:silver_genie/core/widgets/icon_title_details_component.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/subscription/model/subscription_member_model.dart';
import 'package:silver_genie/feature/subscription/store/subscription_store.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => IconTitleDetailsComponentState();
}

class IconTitleDetailsComponentState extends State<SubscriptionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;

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
              padding: const EdgeInsets.all(Dimension.d4),
              child: Column(
                children: [
                  CustomizeTabviewComponent(
                    controller: controller,
                    tabCount: 2,
                    widgetList: const [
                      Tab(icon: Text('Current')),
                      Tab(icon: Text('Previous')),
                    ],
                  ),
                  const SizedBox(
                    height: Dimension.d2,
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: controller,
                      children: List.generate(
                        2,
                        (index) => _SubscriptionUserComponent(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 76,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.grayscale100,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -4),
                  color: AppColors.grayscale300,
                  blurRadius: 8,
                ),
              ],
            ),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: Dimension.d3,
              horizontal: Dimension.d5,
            ),
            child: CustomButton(
              ontap: () {},
              title: 'Buy new subscription',
              showIcon: false,
              iconPath: AppIcons.add,
              size: ButtonSize.normal,
              type: ButtonType.primary,
              expanded: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _SubscriptionUserComponent extends StatelessWidget {
  _SubscriptionUserComponent();
  final store = GetIt.I<SubscriptionStore>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          store.subscriptionMemberList.length,
          (index) => _UserDetailsComponent(
            memberDetails: store.subscriptionMemberList[index],
          ),
        ),
      ),
    );
  }
}

class _UserDetailsComponent extends StatelessWidget {
  const _UserDetailsComponent({required this.memberDetails});
  final SubscriptionMemberModel memberDetails;

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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Avatar.fromSize(
                  imgPath: '',
                  size: AvatarSize.size24,
                ),
                const SizedBox(
                  width: Dimension.d2,
                ),
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
                      style: AppTextStyle.bodyMediumMedium
                          .copyWith(color: AppColors.grayscale800, height: 1.5),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 110,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconTitleDetailsComponent(
                    icon: AppIcons.elderly_person,
                    title: 'Plan',
                    details: memberDetails.plan,
                  ),
                  IconTitleDetailsComponent(
                    icon: AppIcons.medical_services,
                    title: 'Status',
                    details: memberDetails.status,
                  ),
                  IconTitleDetailsComponent(
                    icon: AppIcons.calendar,
                    title: 'Plan ends on',
                    details: memberDetails.planEndsDate,
                  ),
                ],
              ),
            ),
            CustomButton(
              ontap: () {},
              title: 'View Details',
              showIcon: false,
              iconPath: AppIcons.add,
              size: ButtonSize.small,
              type: ButtonType.secondary,
              expanded: true,
            ),
          ],
        ),
      ),
    );
  }
}

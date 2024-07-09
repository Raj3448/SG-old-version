// ignore_for_file: lines_longer_than_80_chars, inference_failure_on_function_invocation

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/custom_drop_down_box.dart';
import 'package:silver_genie/core/widgets/genie_overview.dart';
import 'package:silver_genie/core/widgets/info_dialog.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';
import 'package:silver_genie/feature/members/model/member_model.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';

class CouplePlanPage extends StatefulWidget {
  const CouplePlanPage({
    required this.id,
    required this.pageTitle,
    required this.planList,
    required this.isUpgradable,
    super.key,
  });

  final String id;
  final String pageTitle;
  final List<Price> planList;
  final bool isUpgradable;

  @override
  State<CouplePlanPage> createState() => _CouplePlanPageState();
}

class _CouplePlanPageState extends State<CouplePlanPage> {
  Member? member1;
  Member? member2;
  final memberStore = GetIt.I<MembersStore>();
  final store = GetIt.I<ProductListingStore>();
  late GlobalKey<CustomDropDownBoxState> customDropDownBox1Key;
  late GlobalKey<CustomDropDownBoxState> customDropDownBox2Key;

  @override
  void initState() {
    super.initState();
    customDropDownBox1Key = GlobalKey<CustomDropDownBoxState>();
    customDropDownBox2Key = GlobalKey<CustomDropDownBoxState>();
  }

  void _updateMember(Member? member, bool isFirstMember) {
    setState(() {
      if (isFirstMember) {
        member1 = member;
      } else {
        member2 = member;
      }
    });
  }

  void disableDropDownLists() {
    customDropDownBox1Key.currentState?.disableDropDownList();
    customDropDownBox2Key.currentState?.disableDropDownList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppbar(title: widget.pageTitle),
      backgroundColor: AppColors.white,
      body: GestureDetector(
        onTap: () {
          setState(() {
            disableDropDownLists();
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: Dimension.d4),
          child: SingleChildScrollView(
            child: Observer(
              builder: (context) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: Dimension.d4),
                        PlanPricingDetailsComponent(
                          planName: widget.pageTitle,
                          pricingDetailsList: widget.planList,
                          onSelect: store.updatePlan,
                        ),
                        _buildMemberSelectionText('1. Select family member'),
                        CustomDropDownBox(
                          key: customDropDownBox1Key,
                          selectedMembers: _getSelectedMembers(),
                          memberName: member1?.name,
                          memberList: memberStore.familyMembers.where((member) {
                            if (member.subscriptions == null ||
                                member.subscriptions!.isEmpty) {
                              return true;
                            }

                            return !member.subscriptions!.any(
                              (sub) => sub.subscriptionStatus == 'Active',
                            );
                          }).toList(),
                          updateMember: (member) => _updateMember(member, true),
                        ),
                        const SizedBox(height: Dimension.d2),
                        _buildMemberSelectionText(
                          '2. Select another family member',
                        ),
                        CustomDropDownBox(
                          key: customDropDownBox2Key,
                          selectedMembers: _getSelectedMembers(),
                          memberName: member2?.name,
                          memberList: memberStore.familyMembers.where((member) {
                            if (member.subscriptions == null ||
                                member.subscriptions!.isEmpty) {
                              return true;
                            }

                            return !member.subscriptions!.any(
                              (sub) => sub.subscriptionStatus == 'Active',
                            );
                          }).toList(),
                          updateMember: (member) =>
                              _updateMember(member, false),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: Dimension.d4,
                          ),
                          child: CustomButton(
                            ontap: widget.isUpgradable
                                ? () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const InfoDialog(
                                          showIcon: false,
                                          title: 'Hi there!!',
                                          desc:
                                              'In order to update the Health record\nof a family member, please contact\nSilvergenie',
                                          btnTitle: 'Contact Genie',
                                          showBtnIcon: true,
                                          btnIconPath: AppIcons.phone,
                                        );
                                      },
                                    );
                                  }
                                : (member1 == null ||
                                        member2 == null ||
                                        store.planDetails == null)
                                    ? null
                                    : () {
                                        if (store.planDetails != null) {
                                          store.createSubscription(
                                            priceId: store.planDetails!.id,
                                            productId: int.parse(widget.id),
                                            familyMemberIds: [
                                              member1!.id,
                                              member2!.id,
                                            ],
                                          ).then((result) {
                                            result.fold(
                                              (failure) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Subscription booking failed: $failure.',
                                                    ),
                                                  ),
                                                );
                                              },
                                              (right) {
                                                context.pushNamed(
                                                  RoutesConstants
                                                      .subscriptionDetailsScreen,
                                                  pathParameters: {
                                                    'price':
                                                        '${store.planDetails!.unitAmount}',
                                                    'subscriptionData': json
                                                        .encode(right.toJson()),
                                                    'isCouple': 'true',
                                                  },
                                                );
                                              },
                                            );
                                          });
                                        }
                                      },
                            title: widget.isUpgradable
                                ? 'Upgrade care'
                                : 'Book care',
                            showIcon: false,
                            iconPath: AppIcons.add,
                            size: ButtonSize.normal,
                            type: (member1 == null ||
                                    member2 == null ||
                                    store.planDetails == null)
                                ? ButtonType.disable
                                : ButtonType.primary,
                            expanded: true,
                            iconColor: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    if (store.isLoading) const LoadingWidget(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Member> _getSelectedMembers() {
    return [if (member1 != null) member1!, if (member2 != null) member2!];
  }

  Widget _buildMemberSelectionText(String text) {
    return Text(
      text,
      style: AppTextStyle.bodyMediumMedium.copyWith(
        color: AppColors.grayscale700,
        height: 2,
      ),
    );
  }
}

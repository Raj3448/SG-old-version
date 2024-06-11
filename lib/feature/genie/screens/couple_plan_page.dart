// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
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
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
import 'package:silver_genie/feature/members/model/member_model.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';

class CouplePlanPage extends StatefulWidget {
  final String pageTitle;
  final List<Price> planList;

  const CouplePlanPage({
    required this.pageTitle,
    required this.planList,
    super.key,
  });

  @override
  State<CouplePlanPage> createState() => _CouplePlanPageState();
}

class _CouplePlanPageState extends State<CouplePlanPage> {
  Member? member1;
  Member? member2;
  Price? planDetails;
  final store = GetIt.I<MembersStore>();

  void _updateMember(Member member, bool isFirstMember) {
    setState(() {
      if (isFirstMember) {
        member1 = member;
      } else {
        member2 = member;
      }
    });
  }

  void _updatePlan(Price plan) {
    setState(() {
      planDetails = plan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppbar(title: widget.pageTitle),
      backgroundColor: AppColors.white,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: Dimension.d4),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlanPricingDetailsComponent(
                planName: widget.pageTitle,
                pricingDetailsList: widget.planList,
                onSelect: _updatePlan,
              ),
              _buildMemberSelectionText('1. Select family member'),
              CustomDropDownBox(
                selectedMembers: _getSelectedMembers(),
                memberName: member1?.name,
                memberList: store.members,
                updateMember: (member) => _updateMember(member, true),
              ),
              const SizedBox(
                height: Dimension.d2,
              ),
              _buildMemberSelectionText('2. Select another family member'),
              CustomDropDownBox(
                selectedMembers: _getSelectedMembers(),
                memberName: member2?.name,
                memberList: store.members,
                updateMember: (member) => _updateMember(member, false),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimension.d4),
                child: CustomButton(
                  ontap: (member1 == null ||
                          member2 == null ||
                          planDetails == null)
                      ? null
                      : () {
                          context.pushNamed(
                            RoutesConstants.subscriptionDetailsScreen,
                            pathParameters: {
                              'price': '${planDetails!.unitAmount}',
                            },
                          );
                        },
                  title: 'Book care',
                  showIcon: false,
                  iconPath: AppIcons.add,
                  size: ButtonSize.normal,
                  type: (member1 == null ||
                          member2 == null ||
                          planDetails == null)
                      ? ButtonType.disable
                      : ButtonType.primary,
                  expanded: true,
                  iconColor: AppColors.primary,
                ),
              ),
            ],
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

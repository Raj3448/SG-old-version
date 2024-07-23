// ignore_for_file: inference_failure_on_function_invocation, lines_longer_than_80_chars

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/utils/launch_dialer.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/back_to_home_component.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/feature/home/model/master_data_model.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';

class EmergencyActivation extends StatelessWidget {
  const EmergencyActivation({
    required this.memberStore,
    required this.emergencyHelpline,
    super.key,
  });
  final MembersStore memberStore;
  final EmergencyHelpline emergencyHelpline;
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
            'Emergency'.tr(),
            style: AppTextStyle.bodyXLMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.grayscale900,
            ),
          ),
          Text(
            'When the button is pressed, all emergency services will be activated.'
                .tr(),
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
                        memberStore: memberStore,
                        emergencyHelpline: emergencyHelpline,
                      ),
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
              title: 'Activate Emergency'.tr(),
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
  const _EmergencyActivateBottomSheet({
    required this.memberStore,
    required this.emergencyHelpline,
  });
  final MembersStore memberStore;
  final EmergencyHelpline emergencyHelpline;
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
                    itemBuilder: (context, index) => _ActivateListileComponent(
                      memberName: widget.memberStore.familyMembers[index].name,
                      relation:
                          widget.memberStore.familyMembers[index].relation,
                      onPressed: () async {
                        await launchDialer(
                          widget.emergencyHelpline.contactNumber,
                        ).then(
                          (value) {
                            setState(() {
                              isActivate = true;
                            });
                          },
                        );
                      },
                      imgUrl: widget
                          .memberStore.familyMembers[index].profileImg?.url,
                    ),
                    itemCount: widget.memberStore.familyMembers.length,
                  ),
                ),
              ],
            ),
    );
  }
}

class _ActivateListileComponent extends StatelessWidget {
  const _ActivateListileComponent({
    required this.onPressed,
    required this.memberName,
    required this.imgUrl,
    required this.relation,
  });
  final VoidCallback onPressed;
  final String memberName;
  final String relation;
  final String? imgUrl;
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

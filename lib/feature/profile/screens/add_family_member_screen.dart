// ignore_for_file: deprecated_member_use, inference_failure_on_function_invocation, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/selector.dart';

class AddFamilyMemberScreen extends StatelessWidget {
  const AddFamilyMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 6,
        surfaceTintColor: AppColors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            AppIcons.arrow_backward,
            size: 15,
          ),
        ),
        title: Text(
          'Add new family member',
          style: AppTextStyle.bodyXLMedium.copyWith(height: 1.6),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const _ChangePicDialog();
                  },
                );
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Avatar.fromSize(imgPath: 'imgPath', size: AvatarSize.size56),
                  Container(
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 3),
                      color: AppColors.primary,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: SvgPicture.asset(
                      'assets/icon/edit.svg',
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            CustomButton(
              ontap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const InfoDialog(
                      showIcon: true,
                      title: 'New family member added',
                      desc:
                          'New Family member successfully\nadded to the Health profile.',
                      btnTitle: 'Continue',
                      showBtnIcon: false,
                      btnIconPath: AppIcons.check,
                    );
                  },
                );
              },
              title: 'Show successful container',
              showIcon: false,
              iconPath: AppIcons.add,
              size: ButtonSize.normal,
              type: ButtonType.primary,
              expanded: false,
            ),
            const SizedBox(height: 25),
            CustomButton(
              ontap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const InfoDialog(
                      showIcon: false,
                      title: 'Hi there!!',
                      desc:
                          'In order to update the Health record\nof a family memeber, please contact\n Silvergenie.',
                      btnTitle: 'Contact Genie',
                      showBtnIcon: true,
                      btnIconPath: AppIcons.phone,
                    );
                  },
                );
              },
              title: 'Show contact genie container',
              showIcon: false,
              iconPath: AppIcons.add,
              size: ButtonSize.normal,
              type: ButtonType.primary,
              expanded: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChangePicDialog extends StatelessWidget {
  const _ChangePicDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20)
            .copyWith(top: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Change your picture',
              style: AppTextStyle.bodyXLBold,
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.line),
            const SizedBox(height: 15),
            Selector(
              icon: AppIcons.camera,
              title: 'Take a photo',
              selectorType: SelectorType.withBorder,
              iconColor: AppColors.grayscale900,
              textColor: AppColors.grayscale900,
              ontap: () {},
            ),
            const SizedBox(height: 15),
            Selector(
              icon: AppIcons.folder_open,
              title: 'Choose from file',
              selectorType: SelectorType.withBorder,
              iconColor: AppColors.grayscale900,
              textColor: AppColors.grayscale900,
              ontap: () {},
            ),
            const SizedBox(height: 15),
            Selector(
              icon: AppIcons.delete,
              title: 'Remove',
              selectorType: SelectorType.withBorder,
              iconColor: AppColors.error,
              textColor: AppColors.error,
              ontap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class InfoDialog extends StatelessWidget {
  const InfoDialog({
    required this.showIcon,
    required this.title,
    required this.desc,
    required this.btnTitle,
    required this.showBtnIcon,
    required this.btnIconPath,
    super.key,
  });

  final bool showIcon;
  final String title;
  final String desc;
  final String btnTitle;
  final bool showBtnIcon;
  final IconData btnIconPath;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon)
              Column(
                children: [
                  SvgPicture.asset(
                    'assets/icon/success.svg',
                    height: 88,
                  ),
                  const SizedBox(height: 30),
                ],
              )
            else
              const SizedBox(),
            Text(
              title,
              style: AppTextStyle.bodyXLBold.copyWith(height: 1.5),
            ),
            const SizedBox(height: 8),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyLargeMedium,
            ),
            const SizedBox(height: 30),
            CustomButton(
              ontap: () {},
              title: btnTitle,
              showIcon: showBtnIcon,
              iconPath: btnIconPath,
              size: ButtonSize.normal,
              type: ButtonType.primary,
              expanded: false,
            ),
          ],
        ),
      ),
    );
  }
}

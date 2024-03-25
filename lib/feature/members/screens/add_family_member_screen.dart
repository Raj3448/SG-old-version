// ignore_for_file: deprecated_member_use, inference_failure_on_function_invocation, lines_longer_than_80_chars, strict_raw_type

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/asterisk_label.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/form_components.dart';
import 'package:silver_genie/core/widgets/info_dialog.dart';
import 'package:silver_genie/core/widgets/multidropdown.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/core/widgets/selector.dart';

class AddFamilyMemberScreen extends StatelessWidget {
  const AddFamilyMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PageAppbar(title: 'Add new family member'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          decelerationRate: ScrollDecelerationRate.fast,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: _EditPic()),
              const SizedBox(height: 16),
              const AsteriskLabel(label: 'Full name'),
              const SizedBox(height: 8),
              const CustomTextField(
                hintText: 'Enter your name',
                keyboardType: TextInputType.name,
                large: false,
              ),
              const SizedBox(height: 16),
              const AsteriskLabel(label: 'Gender'),
              const SizedBox(height: 8),
              const MultiDropdown(
                values: [
                  ValueItem(label: 'Male', value: 'Male'),
                  ValueItem(label: 'Female', value: 'Female'),
                  ValueItem(label: 'Other', value: 'MaOtherle'),
                ],
              ),
              const SizedBox(height: 16),
              const AsteriskLabel(label: 'Date of birth'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  showDatePicker(
                    context: context,
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                    initialDate: DateTime.now(),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.line),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Select',
                        style: AppTextStyle.bodyLargeMedium
                            .copyWith(color: AppColors.grayscale700),
                      ),
                      const Spacer(),
                      const Icon(
                        AppIcons.calendar,
                        color: AppColors.grayscale700,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const AsteriskLabel(label: 'Relation'),
              const SizedBox(height: 8),
              const MultiDropdown(
                values: [
                  ValueItem(label: 'Father', value: 'Father'),
                  ValueItem(label: 'Mother', value: 'Mother'),
                  ValueItem(label: 'Sister', value: 'Sister'),
                  ValueItem(label: 'Daughter', value: 'Daughter'),
                  ValueItem(label: 'Wife', value: 'Wife'),
                  ValueItem(label: 'Self', value: 'Self'),
                ],
              ),
              const SizedBox(height: 16),
              const AsteriskLabel(label: 'Mobile number'),
              const SizedBox(height: 8),
              const CustomTextField(
                hintText: 'Type here...',
                keyboardType: TextInputType.number,
                large: false,
              ),
              const SizedBox(height: 16),
              const TextLabel(title: 'Member address'),
              const SizedBox(height: 8),
              const CustomTextField(
                hintText: 'Type here...',
                keyboardType: TextInputType.number,
                large: true,
              ),
              const SizedBox(height: 16),
              const AsteriskLabel(label: 'Country'),
              const SizedBox(height: 8),
              const MultiDropdown(
                values: [
                  ValueItem(label: 'Countries', value: 'Countries'),
                ],
              ),
              const SizedBox(height: 16),
              const TextLabel(title: 'State'),
              const SizedBox(height: 8),
              const MultiDropdown(
                values: [
                  ValueItem(label: 'State', value: 'State'),
                ],
              ),
              const SizedBox(height: 16),
              const TextLabel(title: 'City'),
              const SizedBox(height: 8),
              const MultiDropdown(
                values: [
                  ValueItem(label: 'City', value: 'City'),
                ],
              ),
              const SizedBox(height: 16),
              const TextLabel(title: 'Postal code'),
              const SizedBox(height: 8),
              const CustomTextField(
                hintText: 'Type here...',
                keyboardType: TextInputType.number,
                large: false,
              ),
              const SizedBox(height: 16),
              const AsteriskLabel(label: 'Email ID'),
              const SizedBox(height: 8),
              const CustomTextField(
                hintText: 'Type here...',
                keyboardType: TextInputType.number,
                large: false,
              ),
              const SizedBox(height: 24),
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
                        btnIconPath: AppIcons.add,
                      );
                    },
                  );
                },
                title: 'Add new member',
                showIcon: false,
                iconPath: AppIcons.add,
                size: ButtonSize.normal,
                type: ButtonType.primary,
                expanded: true,
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditPic extends StatelessWidget {
  const _EditPic();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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

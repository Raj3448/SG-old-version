// ignore_for_file: deprecated_member_use, inference_failure_on_function_invocation, lines_longer_than_80_chars, strict_raw_type

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/asterisk_label.dart';
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/form_components.dart';
import 'package:silver_genie/core/widgets/info_dialog.dart';
import 'package:silver_genie/core/widgets/multidropdown.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/members/widgets/pic_dialogs.dart';

class AddEditFamilyMemberScreen extends StatelessWidget {
  const AddEditFamilyMemberScreen({required this.edit, super.key});

  final bool edit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PageAppbar(
        title: edit ? 'Member details'.tr() : 'Add new family member'.tr(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: edit
          ? FixedButton(
              ontap: () {
                GoRouter.of(context).pop();
              },
              btnTitle: 'Save details',
              showIcon: false,
              iconPath: AppIcons.check,
            )
          : FixedButton(
              ontap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const InfoDialog(
                      showIcon: true,
                      title: 'New family member added',
                      desc:
                          'New family member successfully\nadded to the Health profile.',
                      btnTitle: 'Continue',
                      showBtnIcon: false,
                      btnIconPath: AppIcons.check,
                    );
                  },
                );
              },
              btnTitle: 'Add new member',
              showIcon: false,
              iconPath: AppIcons.check,
            ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          decelerationRate: ScrollDecelerationRate.fast,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: EditPic()),
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
              MultiDropdown(
                values: [
                  ValueItem(label: 'Male'.tr(), value: 'Male'),
                  ValueItem(label: 'Female'.tr(), value: 'Female'),
                  ValueItem(label: 'Other'.tr(), value: 'MaOtherle'),
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
                        'Select'.tr(),
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
              MultiDropdown(
                values: [
                  ValueItem(label: 'Father'.tr(), value: 'Father'),
                  ValueItem(label: 'Mother'.tr(), value: 'Mother'),
                  ValueItem(label: 'Sister'.tr(), value: 'Sister'),
                  ValueItem(label: 'Daughter'.tr(), value: 'Daughter'),
                  ValueItem(label: 'Wife'.tr(), value: 'Wife'),
                  ValueItem(label: 'Self'.tr(), value: 'Self'),
                ],
              ),
              const SizedBox(height: 16),
              const AsteriskLabel(label: 'Mobile number'),
              const SizedBox(height: 8),
              const CustomTextField(
                hintText: 'Enter mobile number',
                keyboardType: TextInputType.number,
                large: false,
              ),
              const SizedBox(height: 16),
              const TextLabel(title: 'Member address'),
              const SizedBox(height: 8),
              const CustomTextField(
                hintText: 'Enter address',
                keyboardType: TextInputType.streetAddress,
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
                hintText: 'Enter postal code',
                keyboardType: TextInputType.number,
                large: false,
              ),
              const SizedBox(height: 16),
              const AsteriskLabel(label: 'Email ID'),
              const SizedBox(height: 8),
              const CustomTextField(
                hintText: 'Enter email address',
                keyboardType: TextInputType.emailAddress,
                large: false,
              ),
              const SizedBox(height: Dimension.d20),
            ],
          ),
        ),
      ),
    );
  }
}

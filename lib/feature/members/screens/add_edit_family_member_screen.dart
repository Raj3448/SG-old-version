// ignore_for_file: deprecated_member_use, inference_failure_on_function_invocation, lines_longer_than_80_chars, strict_raw_type

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/asterisk_label.dart';
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/form_components.dart';
import 'package:silver_genie/core/widgets/info_dialog.dart';
import 'package:silver_genie/core/widgets/multidropdown.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/members/widgets/pic_dialogs.dart';

class AddEditFamilyMemberScreen extends StatelessWidget {
  AddEditFamilyMemberScreen({required this.edit, super.key});

  final bool edit;
  final TextEditingController dobContr = TextEditingController();

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
              Center(child: EditPic(storedProfileImage: null,imgUrl: null,)),
              const SizedBox(height: 16),
              const AsteriskLabel(label: 'First name'),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: 'Enter your first name',
                keyboardType: TextInputType.name,
                large: false,
                enabled: true,
              ),
              const SizedBox(height: 16),
              const AsteriskLabel(label: 'Last name'),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: 'Enter your last name',
                keyboardType: TextInputType.name,
                large: false,
                enabled: true,
              ),
              const SizedBox(height: 16),
              const AsteriskLabel(label: 'Last name'),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: 'Enter your last name',
                keyboardType: TextInputType.name,
                large: false,
                enabled: true,
              ),
              const SizedBox(height: 16),
              const AsteriskLabel(label: 'Gender'),
              const SizedBox(height: 8),
              const GenderDropdown(),
              const SizedBox(height: 16),
              const AsteriskLabel(label: 'Date of birth'),
              const SizedBox(height: 8),
              // DateDropdown(controller: dobContr,),
              const SizedBox(height: 16),
              const AsteriskLabel(label: 'Relation'),
              const SizedBox(height: 8),
              const RelationDropdown(),
              const SizedBox(height: 16),
              const AsteriskLabel(label: 'Mobile number'),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: 'Enter mobile number',
                keyboardType: TextInputType.number,
                large: false,
                enabled: true,
              ),
              const SizedBox(height: 16),
              const TextLabel(title: 'Member address'),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: 'Enter address',
                keyboardType: TextInputType.streetAddress,
                large: true,
                enabled: true,
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
              CustomTextField(
                hintText: 'Enter postal code',
                keyboardType: TextInputType.number,
                large: false,
                enabled: true,
              ),
              const SizedBox(height: 16),
              const AsteriskLabel(label: 'Email ID'),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: 'Enter email address',
                keyboardType: TextInputType.emailAddress,
                large: false,
                enabled: true,
                validationLogic: (value) {
                  const regex = r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,}$';
                  if (value!.isEmpty) {
                    return 'Please enter your email address';
                  } else if (!RegExp(regex).hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Dimension.d20),
              const SizedBox(height: Dimension.d5),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use, inference_failure_on_function_invocation, lines_longer_than_80_chars, strict_raw_type

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
      body: const SingleChildScrollView(
        physics: BouncingScrollPhysics(
          decelerationRate: ScrollDecelerationRate.fast,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: EditPic()),
              SizedBox(height: 16),
              AsteriskLabel(label: 'Full name'),
              SizedBox(height: 8),
              CustomTextField(
                hintText: 'Enter your name',
                keyboardType: TextInputType.name,
                large: false,
                enabled: true, 
              ),
              SizedBox(height: 16),
              AsteriskLabel(label: 'Gender'),
              SizedBox(height: 8),
              GenderDropdown(),
              SizedBox(height: 16),
              AsteriskLabel(label: 'Date of birth'),
              SizedBox(height: 8),
              DateDropdown(),
              SizedBox(height: 16),
              AsteriskLabel(label: 'Relation'),
              SizedBox(height: 8),
              RelationDropdown(),
              SizedBox(height: 16),
              AsteriskLabel(label: 'Mobile number'),
              SizedBox(height: 8),
              CustomTextField(
                hintText: 'Enter mobile number',
                keyboardType: TextInputType.number,
                large: false,
                enabled: true,
              ),
              SizedBox(height: 16),
              TextLabel(title: 'Member address'),
              SizedBox(height: 8),
              CustomTextField(
                hintText: 'Enter address',
                keyboardType: TextInputType.streetAddress,
                large: true,
                enabled: true, 
              ),
              SizedBox(height: 16),
              AsteriskLabel(label: 'Country'),
              SizedBox(height: 8),
              MultiDropdown(
                values: [
                  ValueItem(label: 'Countries', value: 'Countries'),
                ],
              ),
              SizedBox(height: 16),
              TextLabel(title: 'State'),
              SizedBox(height: 8),
              MultiDropdown(
                values: [
                  ValueItem(label: 'State', value: 'State'),
                ],
              ),
              SizedBox(height: 16),
              TextLabel(title: 'City'),
              SizedBox(height: 8),
              MultiDropdown(
                values: [
                  ValueItem(label: 'City', value: 'City'),
                ],
              ),
              SizedBox(height: 16),
              TextLabel(title: 'Postal code'),
              SizedBox(height: 8),
              CustomTextField(
                hintText: 'Enter postal code',
                keyboardType: TextInputType.number,
                large: false,
                enabled: true, 
              ),
              SizedBox(height: 16),
              AsteriskLabel(label: 'Email ID'),
              SizedBox(height: 8),
              CustomTextField(
                hintText: 'Enter email address',
                keyboardType: TextInputType.emailAddress,
                large: false,
                enabled: true, 
              ),
              SizedBox(height: Dimension.d20),
            ],
          ),
        ),
      ),
    );
  }
}

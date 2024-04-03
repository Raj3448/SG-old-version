import 'package:flutter/material.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/form_components.dart';
import 'package:silver_genie/core/widgets/info_dialog.dart';
import 'package:silver_genie/core/widgets/multidropdown.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/members/widgets/pic_dialogs.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PageAppbar(title: 'Personal Details'),
      body: SingleChildScrollView(
         physics: const BouncingScrollPhysics(
          decelerationRate: ScrollDecelerationRate.fast,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              const Center(child: EditPic()),
              const SizedBox(
                height: Dimension.d5,
              ),
              const TextLabel(title: 'Full Name'),
              const SizedBox(
                height: Dimension.d2,
              ),
              const CustomTextField(
                hintText: 'Enter your name',
                keyboardType: TextInputType.name,
                large: false,
                enabled: true,
              ),
              const SizedBox(
                height: Dimension.d4,
              ),
              const TextLabel(title: 'Gender',),
              const SizedBox(
                height: Dimension.d2,
              ),
              const MultiDropdown(
                values: [
                  ValueItem(label: 'Male', value: 'Male'),
                  ValueItem(label: 'Female', value: 'Female'),
                  ValueItem(label: 'Other', value: 'MaOtherle'),
                ],
              ),
              const SizedBox(
                height: Dimension.d4,
              ),
              const TextLabel(title: 'Date of birth',),
              const SizedBox(
                height: Dimension.d2,
              ),
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
              const SizedBox(
                height: Dimension.d4,
              ),
              const TextLabel(title: 'Mobile Field'),
              const SizedBox(
                height: Dimension.d2,
              ),
              GestureDetector(
                onTap: (){
                  showDialog(
                    context: context, 
                    builder: (context){
                      return InfoDialog(
                        showIcon: false, 
                        title: 'Want to Update mobile number?', 
                        desc: 'Please contact the SilverGenie team for changing mobile number.', 
                        btnTitle: 'Contact Genie', 
                        showBtnIcon: false, 
                        btnIconPath: AppIcons.add);
                    });
                },
                child: const CustomTextField(
                  hintText: 'Mobile Field',
                  keyboardType: TextInputType.number,
                  large: false,
                  enabled: false,
                ),
              ),
              const SizedBox(
                height: Dimension.d4,
              ),
              const TextLabel(title: 'Email ID'),
              const SizedBox(
                height: Dimension.d2,
              ),
              GestureDetector(
                onTap: (){
                  showDialog(
                    context: context, 
                    builder: (context){
                      return InfoDialog(
                        showIcon: false, 
                        title: 'Want to Update Email ID?', 
                        desc: 'Please contact the SilverGenie team for changing Email ID.', 
                        btnTitle: 'Contact Genie', 
                        showBtnIcon: false, 
                        btnIconPath: AppIcons.phone);
                    });
                },
                child: const CustomTextField(
                  hintText: 'email address',
                  keyboardType: TextInputType.emailAddress,
                  large: false,
                  enabled: false,
                ),
              ),
              const SizedBox(
                height: Dimension.d4,
              ),
              const TextLabel(title: 'Address'),
              const SizedBox(
                height: Dimension.d2,
              ),
              const CustomTextField(
                hintText: 'Address',
                keyboardType: TextInputType.emailAddress,
                large: false,
                enabled: true,
              ),
              const SizedBox(
                height: Dimension.d4,
              ),
              const TextLabel(title: 'Country'),
              const SizedBox(
                height: Dimension.d2,
              ),
              const MultiDropdown(
                values: [
                  ValueItem(label: 'Countries', value: 'Countries'),
                ],
              ),
              const SizedBox(
                height: Dimension.d4,
              ),
              const TextLabel(title: 'State'),
              const SizedBox(
                height: Dimension.d2,
              ),
              const MultiDropdown(
                values: [
                  ValueItem(label: 'State', value: 'State'),
                ],
              ),
              const SizedBox(
                height: Dimension.d4,
              ),
              const TextLabel(title: 'City'),
              const SizedBox(
                height: Dimension.d2,
              ),
              const MultiDropdown(
                values: [
                  ValueItem(label: 'City', value: 'City'),
                ],
              ),
              const SizedBox(
                height: Dimension.d4,
              ),
              const TextLabel(title: 'Postal Code'),
              const SizedBox(
                height: Dimension.d2,
              ),
              const CustomTextField(
                hintText: 'Postal Code',
                keyboardType: TextInputType.number,
                large: false,
                enabled: true,
              ),
              const SizedBox(
                height: Dimension.d10,
              ),
              CustomButton(ontap: (){}, 
              title: 'Save details', 
              showIcon: false, 
              iconPath: AppIcons.add, 
              size: ButtonSize.normal, 
              type: ButtonType.primary, 
              expanded: true)
            ],
          ),
          ),
      ),
    );
  }
}

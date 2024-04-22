// ignore_for_file: inference_failure_on_function_invocation, strict_raw_type, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
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

import 'package:silver_genie/feature/user_profile/store/user_details_store.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final MultiSelectController _genderController = MultiSelectController();
  final MultiSelectController _countryController = MultiSelectController();
  final MultiSelectController _stateController = MultiSelectController();
  final MultiSelectController _cityController = MultiSelectController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();
  late String dateBirth;

  final List<ValueItem<String>> _genderItems = [
    const ValueItem(label: 'Male', value: 'Male'),
    const ValueItem(label: 'Female', value: 'Female'),
    const ValueItem(label: 'Other', value: 'MaOtherle'),
  ];

  final List<ValueItem<String>> _countryItems = [
    const ValueItem(label: 'India', value: 'India'),
    const ValueItem(label: 'Rassia', value: 'Rassia'),
    const ValueItem(label: 'Australia', value: 'Australia'),
  ];

  final List<ValueItem<String>> _stateItems = [
    const ValueItem(label: 'Maharashtra', value: 'Maharashtra'),
    const ValueItem(label: 'Keral', value: 'Keral'),
    const ValueItem(label: 'Karnataka', value: 'Karnataka'),
  ];

  final List<ValueItem<String>> _cityItems = [
    const ValueItem(label: 'Pune', value: 'Pune'),
    const ValueItem(label: 'Solapur', value: 'Solapur'),
    const ValueItem(label: 'Mumbai', value: 'Mumbai'),
  ];

  @override
  void initState() {
    super.initState();
    final userDetails = GetIt.instance.get<UserDetailStore>();
    _fullNameController.text = userDetails.userDetails.fullname;
    dateBirth = userDetails.userDetails.dateBirth;

    _genderController.selectedOptions.add(_genderItems[0]);
    _mobileController.text = userDetails.userDetails.mobileNum;
    _emailController.text = userDetails.userDetails.emailId;
    _addressController.text = userDetails.userDetails.address;
    _countryController.selectedOptions.add(_countryItems[0]);
    _stateController.selectedOptions.add(_stateItems[0]);
    _cityController.selectedOptions.add(_cityItems[0]);
    _postalController.text = userDetails.userDetails.postalCode.toString();
  }

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: EditPic()),
              const SizedBox(
                height: Dimension.d5,
              ),
              const TextLabel(title: 'Full Name'),
              const SizedBox(
                height: Dimension.d2,
              ),
              CustomTextField(
                hintText: 'Enter your name',
                keyboardType: TextInputType.name,
                large: false,
                enabled: true,
                controller: _fullNameController,
              ),
              const SizedBox(
                height: Dimension.d4,
              ),
              const TextLabel(
                title: 'Gender',
              ),
              const SizedBox(
                height: Dimension.d2,
              ),
              MultiDropdown(
                values: _genderItems,
                controller: _genderController,
              ),
              const SizedBox(
                height: Dimension.d4,
              ),
              const TextLabel(
                title: 'Date of birth',
              ),
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
                        dateBirth,
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
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const InfoDialog(
                        showIcon: true,
                        title: 'Want to Update mobile number?',
                        desc:
                            'Please contact the SilverGenie team for changing mobile number.',
                        btnTitle: 'Contact Genie',
                        showBtnIcon: true,
                        btnIconPath: AppIcons.phone,
                      );
                    },
                  );
                },
                child: CustomTextField(
                  hintText: 'Mobile Field',
                  keyboardType: TextInputType.number,
                  large: false,
                  enabled: false,
                  controller: _mobileController,
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
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const InfoDialog(
                        showIcon: true,
                        title: 'Want to Update Email ID?',
                        desc:
                            'Please contact the SilverGenie team for changing Email ID.',
                        btnTitle: 'Contact Genie',
                        showBtnIcon: true,
                        btnIconPath: AppIcons.phone,
                      );
                    },
                  );
                },
                child: CustomTextField(
                  hintText: 'email address',
                  keyboardType: TextInputType.emailAddress,
                  large: false,
                  enabled: false,
                  controller: _emailController,
                ),
              ),
              const SizedBox(
                height: Dimension.d4,
              ),
              const TextLabel(title: 'Address'),
              const SizedBox(
                height: Dimension.d2,
              ),
              CustomTextField(
                hintText: 'Address',
                keyboardType: TextInputType.emailAddress,
                large: false,
                enabled: true,
                controller: _addressController,
              ),
              const SizedBox(
                height: Dimension.d4,
              ),
              const TextLabel(title: 'Country'),
              const SizedBox(
                height: Dimension.d2,
              ),
              MultiDropdown(
                controller: _countryController,
                values: _countryItems,
              ),
              const SizedBox(
                height: Dimension.d4,
              ),
              const TextLabel(title: 'State'),
              const SizedBox(
                height: Dimension.d2,
              ),
              MultiDropdown(
                values: _stateItems,
                controller: _stateController,
              ),
              const SizedBox(
                height: Dimension.d4,
              ),
              const TextLabel(title: 'City'),
              const SizedBox(
                height: Dimension.d2,
              ),
              MultiDropdown(
                values: _cityItems,
                controller: _cityController,
              ),
              const SizedBox(
                height: Dimension.d4,
              ),
              const TextLabel(title: 'Postal Code'),
              const SizedBox(
                height: Dimension.d2,
              ),
              CustomTextField(
                hintText: 'Postal Code',
                keyboardType: TextInputType.number,
                large: false,
                enabled: true,
                controller: _postalController,
              ),
              const SizedBox(
                height: Dimension.d10,
              ),
              CustomButton(
                ontap: () {
                  final userDetailsStore =
                      GetIt.instance.get<UserDetailStore>();
                  var userDetails = userDetailsStore.userDetails;
                  userDetails = userDetails.copyWith(
                    fullname: _fullNameController.text,
                    emailId: _emailController.text,
                    mobileNum: _mobileController.text,
                  );
                  userDetailsStore.updateUserDetails(userDetails);
                  Navigator.of(context).pop();
                },
                title: 'Save details',
                showIcon: false,
                iconPath: AppIcons.add,
                size: ButtonSize.normal,
                type: ButtonType.primary,
                expanded: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

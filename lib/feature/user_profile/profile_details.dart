// ignore_for_file: inference_failure_on_function_invocation, strict_raw_type, lines_longer_than_80_chars

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes.dart';
import 'package:silver_genie/core/utils/country_list.dart';
import 'package:silver_genie/core/utils/launch_dialer.dart';
import 'package:silver_genie/core/widgets/asterisk_label.dart';
import 'package:silver_genie/core/widgets/error_state_component.dart';
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/form_components.dart';
import 'package:silver_genie/core/widgets/info_dialog.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/multidropdown.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';
import 'package:silver_genie/feature/members/widgets/pic_dialogs.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';
import 'package:silver_genie/feature/user_profile/store/user_details_store.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final MultiSelectController _genderController = MultiSelectController();
  final MultiSelectController _countryController = MultiSelectController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  File? storedImageFile;
  String? profileImgUrl;

  final List<ValueItem<String>> _genderItems = [
    const ValueItem(label: 'Male', value: 'Male'),
    const ValueItem(label: 'Female', value: 'Female'),
    const ValueItem(label: 'Other', value: 'Other'),
  ];

  final List<ValueItem<String>> _countryItems = List.generate(
    countries.length,
    (index) => ValueItem(
      label: countries[index].name,
      value: countries[index].isoCode,
    ),
  );
  final store = GetIt.I<UserDetailStore>();
  bool isAlreadyhaveProfileImg = false;
  bool isImageUpdate = false;
  void _updateProfileImage(File? image) {
    storedImageFile = image;
    isImageUpdate = true;
  }

  bool autoValidate = false;

  int? selectedGenderIndex;
  int? _selectedCountryIndex;

  final globalkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeControllers();

    reaction((_) => store.updateFailureMessage, (_) {
      if (store.updateFailureMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(store.updateFailureMessage!),
            duration: const Duration(seconds: 5),
          ),
        );

        store.updateFailureMessage = null;
      }
    });

    reaction((_) => store.updateSuccess, (_) {
      if (store.updateSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Updated successfully!'),
            duration: Duration(seconds: 3),
          ),
        );
        store.updateSuccess = false;

        /// Refreshing the member store, name there can get updated
        GetIt.I<MembersStore>().refresh();
        context.pop();
      }
    });
  }

  void _initializeControllers() {
    final userDetails = store.userDetails!;
    _firstNameController.text = userDetails.firstName;
    _lastNameController.text = userDetails.lastName;
    _dobController.text =
        DateFormat('yyyy-MM-dd').format(userDetails.dateOfBirth);
    _mobileController.text = userDetails.phoneNumber;
    _emailController.text = userDetails.email;

    // Set profile image if available
    if (userDetails.profileImg != null) {
      isAlreadyhaveProfileImg = true;
      profileImgUrl = userDetails.profileImg!.url;
    }

    // Set address fields if available
    if (userDetails.address != null) {
      _selectedCountryIndex = _countryItems.indexWhere(
        (element) => element.value == userDetails.address!.country,
      );
      _cityController.text = userDetails.address!.city;
      _stateController.text = userDetails.address!.state;
      _addressController.text = userDetails.address!.streetAddress;
      _postalController.text = userDetails.address!.postalCode;
    }
    selectedGenderIndex =
        _genderItems.indexWhere((item) => item.value == userDetails.gender);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Observer(
        builder: (context) {
          var user = store.userDetails;

          if (user == null) {
            return const SafeArea(
              child:
                  ErrorStateComponent(errorType: ErrorType.somethinWentWrong),
            );
          }
          return Stack(
            children: [
              Scaffold(
                backgroundColor: AppColors.white,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: FixedButton(
                  ontap: () async {
                    setState(() {
                      autoValidate = true;
                    });
                    if (!globalkey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all the fields'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                      return;
                    }
                    user = user!.copyWith(
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      email: _emailController.text,
                      phoneNumber: _mobileController.text,
                      dateOfBirth: DateTime.parse(_dobController.text),
                      gender: _genderController.selectedOptions.first.value
                          .toString(),
                      address: Address(
                        id: user!.address?.id ?? -1,
                        state: _stateController.text,
                        city: _cityController.text,
                        streetAddress: _addressController.text,
                        postalCode: _postalController.text,
                        country: _countryController.selectedOptions.first.value
                            .toString(),
                      ),
                    );
                    if (storedImageFile != null) {
                      store.updateUserDataWithProfileImg(
                        fileImage: storedImageFile!,
                        userInstance: user!,
                      );
                      return;
                    }
                    if (isAlreadyhaveProfileImg && isImageUpdate) {
                      if (storedImageFile == null) {
                        user = user?.copyWith(profileImg: null);
                      }
                    }
                    store.updateUserDetails(user!);
                  },
                  btnTitle: 'Save details',
                  showIcon: false,
                  iconPath: AppIcons.add,
                ),
                appBar: const PageAppbar(title: 'Personal Details'),
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                    decelerationRate: ScrollDecelerationRate.fast,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: globalkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: Dimension.d6),
                          Center(
                            child: EditPic(
                              onImageSelected: _updateProfileImage,
                              imgUrl: profileImgUrl,
                            ),
                          ),
                          const SizedBox(height: Dimension.d5),
                          const AsteriskLabel(label: 'First name'),
                          const SizedBox(height: Dimension.d2),
                          CustomTextField(
                            hintText: 'Enter your first name',
                            keyboardType: TextInputType.name,
                            large: false,
                            enabled: true,
                            controller: _firstNameController,
                            autovalidateMode: autoValidate
                                ? AutovalidateMode.onUserInteraction
                                : AutovalidateMode.disabled,
                            validationLogic: (value) {
                              if (value!.isEmpty) {
                                return 'Please your first name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: Dimension.d4),
                          const AsteriskLabel(label: 'Last name'),
                          const SizedBox(height: Dimension.d2),
                          CustomTextField(
                            hintText: 'Enter your last name',
                            keyboardType: TextInputType.name,
                            large: false,
                            enabled: true,
                            controller: _lastNameController,
                            autovalidateMode: autoValidate
                                ? AutovalidateMode.onUserInteraction
                                : AutovalidateMode.disabled,
                            validationLogic: (value) {
                              if (value!.isEmpty) {
                                return 'Please your last name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: Dimension.d4),
                          const AsteriskLabel(label: 'Gender'),
                          const SizedBox(height: Dimension.d2),
                          MultiSelectFormField(
                            controller: _genderController,
                            showClear: false,
                            values: _genderItems,
                            selectedOptions: selectedGenderIndex == -1 ? null : [
                              _genderItems[selectedGenderIndex!],
                            ],
                            validator: (selectedItems) {
                              if (selectedItems == null) {
                                return 'Please select a gender';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: Dimension.d4),
                          const AsteriskLabel(label: 'Date of birth'),
                          const SizedBox(height: Dimension.d2),
                          DateDropdown(
                            controller: _dobController,
                          ),
                          const SizedBox(height: Dimension.d4),
                          const AsteriskLabel(label: 'Mobile number'),
                          const SizedBox(height: Dimension.d2),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return InfoDialog(
                                    showIcon: true,
                                    title: 'Want to Update mobile number?',
                                    desc:
                                        'Please contact the SilverGenie team for changing mobile number.',
                                    btnTitle: 'Contact Genie',
                                    showBtnIcon: true,
                                    btnIconPath: AppIcons.phone,
                                    onTap: () {
                                      launchDialer(homeStore
                                                  .getMasterDataModel
                                                  ?.masterData
                                                  .contactUs.contactNumber ??
                                              '')
                                          .then((value) => GoRouter.of(context).pop(),);
                                    },
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
                          const SizedBox(height: Dimension.d4),
                          const AsteriskLabel(label: 'Email ID'),
                          const SizedBox(height: Dimension.d2),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return InfoDialog(
                                    showIcon: true,
                                    title: 'Want to Update Email ID?',
                                    desc:
                                        'Please contact the SilverGenie team for changing Email ID.',
                                    btnTitle: 'Contact Genie',
                                    showBtnIcon: true,
                                    btnIconPath: AppIcons.phone,
                                    onTap: () {
                                      launchDialer(homeStore
                                                  .getMasterDataModel
                                                  ?.masterData
                                                  .contactUs.contactNumber ??
                                              '')
                                          .then((value) => GoRouter.of(context).pop(),);
                                    },
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
                          const SizedBox(height: Dimension.d4),
                          const AsteriskLabel(label: 'Address'),
                          const SizedBox(height: Dimension.d2),
                          CustomTextField(
                            hintText: 'Address',
                            keyboardType: TextInputType.emailAddress,
                            large: false,
                            enabled: true,
                            controller: _addressController,
                            autovalidateMode: autoValidate
                                ? AutovalidateMode.onUserInteraction
                                : AutovalidateMode.disabled,
                            validationLogic: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: Dimension.d4),
                          const AsteriskLabel(label: 'Country'),
                          const SizedBox(height: Dimension.d2),
                          MultiSelectFormField(
                            controller: _countryController,
                            showClear: false,
                            values: _countryItems,
                            validator: (selectedItems) {
                              if (selectedItems == null) {
                                return 'Please select country';
                              }
                              return null;
                            },
                            selectedOptions: _selectedCountryIndex == -1 ||
                                    _selectedCountryIndex == null
                                ? null
                                : [_countryItems[_selectedCountryIndex!]],
                          ),
                          const SizedBox(height: Dimension.d4),
                          const AsteriskLabel(label: 'State'),
                          const SizedBox(height: Dimension.d2),
                          CustomTextField(
                            hintText: 'State',
                            keyboardType: TextInputType.emailAddress,
                            large: false,
                            enabled: true,
                            controller: _stateController,
                            autovalidateMode: autoValidate
                                ? AutovalidateMode.onUserInteraction
                                : AutovalidateMode.disabled,
                            validationLogic: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the state';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: Dimension.d4),
                          const AsteriskLabel(label: 'City'),
                          const SizedBox(height: Dimension.d2),
                          CustomTextField(
                            hintText: 'City',
                            keyboardType: TextInputType.emailAddress,
                            large: false,
                            enabled: true,
                            controller: _cityController,
                            autovalidateMode: autoValidate
                                ? AutovalidateMode.onUserInteraction
                                : AutovalidateMode.disabled,
                            validationLogic: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the city';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: Dimension.d4),
                          const AsteriskLabel(label: 'Postal Code'),
                          const SizedBox(height: Dimension.d2),
                          CustomTextField(
                            hintText: 'Postal Code',
                            keyboardType: TextInputType.number,
                            large: false,
                            enabled: true,
                            controller: _postalController,
                            autovalidateMode: autoValidate
                                ? AutovalidateMode.onUserInteraction
                                : AutovalidateMode.disabled,
                            validationLogic: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your postal code';
                              } else if (value.length > 6 || value.length < 6) {
                                return 'Please enter 6 digits postal code';
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
                ),
              ),
              if (store.isUpdatingUserInfo)
                const Material(
                  color: Colors.transparent,
                  child: LoadingWidget(),
                ),
            ],
          );
        },
      ),
    );
  }
}

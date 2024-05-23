// ignore_for_file: inference_failure_on_function_invocation, strict_raw_type, lines_longer_than_80_chars

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/form_components.dart';
import 'package:silver_genie/core/widgets/info_dialog.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/multidropdown.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
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
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
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

  bool _isInitialize = false;
  final store = GetIt.I<UserDetailStore>();
  bool isAlreadyhaveProfileImg = false;
  bool isImageUpdate = false;
  void _updateProfileImage(File? image) {
    storedImageFile = image;
    isImageUpdate = true;
  }

  int? selectedGenderIndex;

  final globalkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
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
      _cityController.text = userDetails.address!.city;
      _stateController.text = userDetails.address!.state;
      _countryController.text = userDetails.address!.country;
      _addressController.text = userDetails.address!.streetAddress;
      _postalController.text = userDetails.address!.postalCode;
    }

    final userGender = userDetails.gender;
    selectedGenderIndex =
        _genderItems.indexWhere((item) => item.value == userGender);

    // if (!_isInitialize) {
    //   setState(() {
    //     _isInitialize = true;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.white,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FixedButton(
                ontap: () async {
                  if (!globalkey.currentState!.validate()) {
                    return;
                  }
                  User? user;
                  try {
                    user = store.userDetails!;
                  } catch (error) {
                    _checkWhatToDo();
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
                        id: user.address!.id,
                        state: _stateController.text,
                        city: _cityController.text,
                        streetAddress: _addressController.text,
                        postalCode: _postalController.text,
                        country: _countryController.text),
                  );

                  if (storedImageFile != null) {
                    store
                      ..updateUserDataWithProfileImg(
                          fileImage: storedImageFile!, userInstance: user)
                      ..getUserDetails();
                    _checkWhatToDo();
                    return;
                  } else if (isAlreadyhaveProfileImg && isImageUpdate) {
                    if (storedImageFile == null) {
                      user = user.copyWith(profileImg: null);
                    }
                  }
                  await store.updateUserDetails(user);
                  store.getUserDetails();
                  _checkWhatToDo();
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
                        Center(
                            child: EditPic(
                          onImageSelected: _updateProfileImage,
                          imgUrl: profileImgUrl,
                        )),
                        const SizedBox(height: Dimension.d5),
                        const TextLabel(title: 'First Name'),
                        const SizedBox(height: Dimension.d2),
                        CustomTextField(
                          hintText: 'Enter your first name',
                          keyboardType: TextInputType.name,
                          large: false,
                          enabled: true,
                          controller: _firstNameController,
                          validationLogic: (value) {
                            if (value!.isEmpty) {
                              return 'Please your first name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: Dimension.d4),
                        const TextLabel(title: 'Last Name'),
                        const SizedBox(height: Dimension.d2),
                        CustomTextField(
                          hintText: 'Enter your last name',
                          keyboardType: TextInputType.name,
                          large: false,
                          enabled: true,
                          controller: _lastNameController,
                          validationLogic: (value) {
                            if (value!.isEmpty) {
                              return 'Please your last name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: Dimension.d4),
                        const TextLabel(title: 'Gender'),
                        const SizedBox(height: Dimension.d2),
                        MultiDropdown(
                          values: _genderItems,
                          controller: _genderController,
                          selectedOptions: [_genderItems[selectedGenderIndex!]],
                        ),
                        const SizedBox(height: Dimension.d4),
                        const TextLabel(title: 'Date of birth'),
                        const SizedBox(height: Dimension.d2),
                        DateDropdown(controller: _dobController),
                        const SizedBox(height: Dimension.d4),
                        const TextLabel(title: 'Mobile Field'),
                        const SizedBox(height: Dimension.d2),
                        const SizedBox(height: Dimension.d2),
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
                        const SizedBox(height: Dimension.d4),
                        const SizedBox(height: Dimension.d4),
                        const TextLabel(title: 'Email ID'),
                        const SizedBox(height: Dimension.d2),
                        const SizedBox(height: Dimension.d2),
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
                        const SizedBox(height: Dimension.d4),
                        const SizedBox(height: Dimension.d4),
                        const TextLabel(title: 'Address'),
                        const SizedBox(height: Dimension.d2),
                        const SizedBox(height: Dimension.d2),
                        CustomTextField(
                          hintText: 'Address',
                          keyboardType: TextInputType.emailAddress,
                          large: false,
                          enabled: true,
                          controller: _addressController,
                          validationLogic: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: Dimension.d4),
                        const SizedBox(height: Dimension.d4),
                        const TextLabel(title: 'Country'),
                        const SizedBox(height: Dimension.d2),
                        const SizedBox(height: Dimension.d2),
                        CustomTextField(
                          hintText: 'Country',
                          keyboardType: TextInputType.emailAddress,
                          large: false,
                          enabled: true,
                          controller: _countryController,
                          validationLogic: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the country';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: Dimension.d4),
                        const SizedBox(height: Dimension.d4),
                        const TextLabel(title: 'State'),
                        const SizedBox(height: Dimension.d2),
                        const SizedBox(height: Dimension.d2),
                        CustomTextField(
                          hintText: 'State',
                          keyboardType: TextInputType.emailAddress,
                          large: false,
                          enabled: true,
                          controller: _stateController,
                          validationLogic: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the state';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: Dimension.d4),
                        const SizedBox(height: Dimension.d4),
                        const TextLabel(title: 'City'),
                        const SizedBox(height: Dimension.d2),
                        const SizedBox(height: Dimension.d2),
                        CustomTextField(
                          hintText: 'City',
                          keyboardType: TextInputType.emailAddress,
                          large: false,
                          enabled: true,
                          controller: _cityController,
                          validationLogic: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the city';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: Dimension.d4),
                        const SizedBox(height: Dimension.d4),
                        const TextLabel(title: 'Postal Code'),
                        const SizedBox(height: Dimension.d2),
                        const SizedBox(height: Dimension.d2),
                        CustomTextField(
                          hintText: 'Postal Code',
                          keyboardType: TextInputType.number,
                          large: false,
                          enabled: true,
                          controller: _postalController,
                          validationLogic: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the postalcode';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: Dimension.d20),
                        const SizedBox(height: Dimension.d5),
                        const SizedBox(height: Dimension.d20),
                        const SizedBox(height: Dimension.d5),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (store.isUpdatingUserInfo) const LoadingWidget()
          ],
        );
      },
    );
  }

  void _checkWhatToDo() {
    if (store.updateFailureMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(store.updateFailureMessage!),
        duration: const Duration(seconds: 3),
      ));

      return;
    }
    context.pop();
  }
}

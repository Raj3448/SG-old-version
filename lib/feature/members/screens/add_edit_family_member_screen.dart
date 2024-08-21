// ignore_for_file: deprecated_member_use, inference_failure_on_function_invocation, lines_longer_than_80_chars, strict_raw_type, avoid_bool_literals_in_conditional_expressions

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
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/form_components.dart';
import 'package:silver_genie/core/widgets/info_dialog.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/multidropdown.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/bookings/store/booking_service_store.dart';
import 'package:silver_genie/feature/members/model/member_model.dart';
import 'package:silver_genie/feature/members/repo/member_service.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';
import 'package:silver_genie/feature/members/widgets/pic_dialogs.dart';
import 'package:silver_genie/feature/user_profile/store/user_details_store.dart';

class AddEditFamilyMemberScreen extends StatefulWidget {
  const AddEditFamilyMemberScreen({
    required this.edit,
    required this.isSelf,
    super.key,
  });

  final bool edit;
  final bool isSelf;

  @override
  State<AddEditFamilyMemberScreen> createState() =>
      _AddEditFamilyMemberScreenState();
}

class _AddEditFamilyMemberScreenState extends State<AddEditFamilyMemberScreen> {
  final firstNameContr = TextEditingController();
  final lastNameContr = TextEditingController();
  final MultiSelectController genderContr = MultiSelectController();
  final dobContr = TextEditingController();
  final MultiSelectController relationContr = MultiSelectController();
  final phoneNumberContr = TextEditingController();
  final emailContr = TextEditingController();
  final memberAddressContr = TextEditingController();
  final MultiSelectController countryContr = MultiSelectController();
  final stateContr = TextEditingController();
  final cityContr = TextEditingController();
  final postalCodeContr = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final memberService = GetIt.I<MemberServices>();
  final memberStore = GetIt.I<MembersStore>();

  final List<ValueItem<String>> _genderItems = [
    const ValueItem(label: 'Male', value: 'Male'),
    const ValueItem(label: 'Female', value: 'Female'),
    const ValueItem(label: 'Other', value: 'Other'),
  ];
  List<ValueItem<String>> _relationList = [];
  late Member _member;
  late final int? selectedGenderIndex;
  int? relationIndex;
  String? profileImgUrl;
  File? storeImageFile;
  bool isImageUpdate = false;
  bool autoValidate = false;

  bool isAlreadyhaveProfileImg = false;

  void _updateImageFile(File? imageFile) {
    storeImageFile = imageFile;
    isImageUpdate = true;
  }

  int? _selectedCountryIndex;

  final List<ValueItem<String>> _countryItems = List.generate(
    countries.length,
    (index) => ValueItem(
      label: countries[index].name,
      value: countries[index].isoCode,
    ),
  );

  @override
  void initState() {
    super.initState();

    _relationList = [
      ValueItem(label: 'Father'.tr(), value: 'Father'),
      ValueItem(label: 'Mother'.tr(), value: 'Mother'),
      ValueItem(label: 'Sister'.tr(), value: 'Sister'),
      ValueItem(label: 'Brother'.tr(), value: 'Brother'),
      ValueItem(label: 'Daughter'.tr(), value: 'Daughter'),
      ValueItem(label: 'Son'.tr(), value: 'Son'),
      ValueItem(label: 'Wife'.tr(), value: 'Wife'),
      if (widget.isSelf == true) ValueItem(label: 'Self'.tr(), value: 'self'),
    ];

    if (widget.edit) {
      _initializeControllers();
    } else if (widget.isSelf) {
      _initializeSelfMemberControllers();
    }

    reaction((_) => memberStore.addOrEditMemberFailure, (_) {
      if (memberStore.addOrEditMemberFailure != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(memberStore.addOrEditMemberFailure!),
            duration: const Duration(seconds: 3),
          ),
        );
        memberStore.addOrEditMemberFailure = null;
      }
    });

    reaction((_) => memberStore.addOrEditMemberSuccessful,
        (successValue) async {
      if (successValue == null) return;

      await showDialog(
        context: context,
        builder: (context) {
          return InfoDialog(
            showIcon: true,
            title: successValue,
            desc: widget.edit
                ? 'Family member updated successfully.'
                : 'New family member successfully\nadded to the Health profile.',
            btnTitle: 'Continue',
            showBtnIcon: false,
            btnIconPath: AppIcons.check,
            onTap: () {
              GoRouter.of(context).pop();
            },
          );
        },
      );
      GetIt.I<MembersStore>().refresh();
      GetIt.I<UserDetailStore>().refresh();
      GetIt.I<BookingServiceStore>().refresh();
      context
        ..pop()
        ..pop();
      memberStore.addOrEditMemberSuccessful = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.white,
              appBar: PageAppbar(
                title: widget.edit
                    ? 'Member details'.tr()
                    : 'Add new family member'.tr(),
              ),
              resizeToAvoidBottomInset: true,
              bottomNavigationBar: SafeArea(
                  top: false,
                  child: widget.edit
                      ? FixedButton(
                          ontap: () {
                            setState(() {
                              autoValidate = true;
                            });
                            if (!formKey.currentState!.validate()) {
                              return;
                            }
                            final genderSelectedValue =
                                genderContr.selectedOptions.first;
                            final relationSelectedValue =
                                relationContr.selectedOptions.first;
                            final dateObject =
                                DateFormat('dd/MM/yyyy').parse(dobContr.text);
                            final formattedDate =
                                DateFormat('yyyy-MM-dd').format(dateObject);
                            final updatedData = <String, dynamic>{
                              'firstName': firstNameContr.text,
                              'lastName': lastNameContr.text,
                              'dob': formattedDate,
                              'relation':
                                  relationSelectedValue.value.toString().trim(),
                              'gender':
                                  genderSelectedValue.value.toString().trim(),
                              'address': {
                                'state': stateContr.text,
                                'city': cityContr.text,
                                'streetAddress': memberAddressContr.text,
                                'postalCode': postalCodeContr.text,
                                'country': countryContr
                                    .selectedOptions.first.value
                                    .toString(),
                              },
                              'profileImg':
                                  memberStore.activeMember!.profileImg?.id,
                            };
                            if (storeImageFile != null) {
                              memberStore.updateMemberDataWithProfileImg(
                                id: _member.id.toString(),
                                fileImage: storeImageFile!,
                                memberInstance: updatedData,
                              );
                              return;
                            }
                            if (isAlreadyhaveProfileImg && isImageUpdate) {
                              if (storeImageFile == null) {
                                updatedData['profileImg'] = null;
                              }
                            }
                            memberStore.updateMember(
                              id: _member.id,
                              updatedData: updatedData,
                            );
                          },
                          btnTitle: 'Save details',
                          showIcon: false,
                          iconPath: AppIcons.check,
                        )
                      : FixedButton(
                          ontap: () async {
                            setState(() {
                              autoValidate = true;
                            });
                            if (!formKey.currentState!.validate()) {
                              return;
                            }
                            final genderSelectedValue =
                                genderContr.selectedOptions.first;
                            final relationSelectedValue =
                                relationContr.selectedOptions.first;
                            final dateObject =
                                DateFormat('dd/MM/yyyy').parse(dobContr.text);
                            final formattedDate =
                                DateFormat('yyyy-MM-dd').format(dateObject);
                            memberStore.addNewFamilyMember(
                              memberData: {
                                'self': widget.isSelf ? true : false,
                                'relation': relationSelectedValue.value
                                    .toString()
                                    .trim(),
                                'gender':
                                    genderSelectedValue.value.toString().trim(),
                                'firstName': firstNameContr.text,
                                'lastName': lastNameContr.text,
                                'dob': formattedDate,
                                'email': emailContr.text,
                                'phoneNumber':
                                    '91 ${phoneNumberContr.text.trim()}',
                                'address': {
                                  'state': stateContr.text.trim(),
                                  'city': cityContr.text.trim(),
                                  'streetAddress':
                                      memberAddressContr.text.trim(),
                                  'postalCode': postalCodeContr.text.trim(),
                                  'country': countryContr
                                      .selectedOptions.first.value
                                      .toString(),
                                },
                              },
                              fileImage: storeImageFile,
                            );
                          },
                          btnTitle: 'Add new member',
                          showIcon: false,
                          iconPath: AppIcons.check,
                        )),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.fast,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Dimension.d6),
                      Center(
                        child: EditPic(
                          onImageSelected: _updateImageFile,
                          imgUrl: profileImgUrl,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AsteriskLabel(label: 'First name'),
                            const SizedBox(height: 8),
                            CustomTextField(
                              hintText: 'Enter your first name',
                              keyboardType: TextInputType.name,
                              controller: firstNameContr,
                              large: false,
                              enabled: widget.isSelf ? false : true,
                              onChanged: (value) => firstNameContr.text = value,
                              autovalidateMode: autoValidate
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                              validationLogic: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            const AsteriskLabel(label: 'Last name'),
                            const SizedBox(height: 8),
                            CustomTextField(
                              hintText: 'Enter your last name',
                              keyboardType: TextInputType.name,
                              controller: lastNameContr,
                              large: false,
                              enabled: widget.isSelf ? false : true,
                              autovalidateMode: autoValidate
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                              validationLogic: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            const AsteriskLabel(label: 'Gender'),
                            const SizedBox(height: 8),
                            MultiSelectFormField(
                              showClear: false,
                              selectedOptions: (widget.edit || widget.isSelf) &&
                                      (selectedGenderIndex != -1)
                                  ? [_genderItems[selectedGenderIndex!]]
                                  : null,
                              controller: genderContr,
                              values: _genderItems,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select the gender';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            const AsteriskLabel(label: 'Date of birth'),
                            const SizedBox(height: 8),
                            DateDropdown(
                              controller: dobContr,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select the DOB';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            const AsteriskLabel(label: 'Relation'),
                            const SizedBox(height: 8),
                            MultiSelectFormField(
                              enabled: !widget.isSelf ? true : false,
                              showClear: false,
                              selectedOptions: widget.isSelf
                                  ? [_relationList[7]]
                                  : widget.edit &&
                                          relationIndex != null &&
                                          relationIndex! >= 0 &&
                                          relationIndex! < _relationList.length
                                      ? [_relationList[relationIndex!]]
                                      : [],
                              controller: relationContr,
                              values: _relationList,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select the relation';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            const AsteriskLabel(label: 'Mobile number'),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                if (widget.edit || widget.isSelf) {
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
                                          launchDialer(
                                            homeStore
                                                    .getMasterDataModel
                                                    ?.masterData
                                                    .contactUs
                                                    .contactNumber ??
                                                '',
                                          ).then(
                                            (value) =>
                                                GoRouter.of(context).pop(),
                                          );
                                        },
                                      );
                                    },
                                  );
                                }
                              },
                              child: Stack(
                                children: [
                                  CustomTextField(
                                    hintText: 'Enter mobile number',
                                    keyboardType: TextInputType.number,
                                    controller: widget.edit || widget.isSelf
                                        ? null
                                        : phoneNumberContr,
                                    initialValue:  widget.edit || widget.isSelf ? '+${phoneNumberContr.text}' : null,
                                    large: false,
                                    enabled: widget.edit || widget.isSelf
                                        ? false
                                        : true,
                                    autovalidateMode: autoValidate
                                        ? AutovalidateMode.onUserInteraction
                                        : AutovalidateMode.disabled,
                                    validationLogic:
                                        (widget.edit || widget.isSelf)
                                            ? null
                                            : (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter your phone number';
                                                }
                                                if (value.length != 10) {
                                                  return 'Please enter atleast 10 digits phone number';
                                                }
                                                return null;
                                              },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            const AsteriskLabel(label: 'Email ID'),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                if (widget.edit || widget.isSelf) {
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
                                          launchDialer(
                                            homeStore
                                                    .getMasterDataModel
                                                    ?.masterData
                                                    .contactUs
                                                    .contactNumber ??
                                                '',
                                          ).then(
                                            (value) =>
                                                GoRouter.of(context).pop(),
                                          );
                                        },
                                      );
                                    },
                                  );
                                }
                              },
                              child: CustomTextField(
                                hintText: 'Enter email address',
                                keyboardType: TextInputType.emailAddress,
                                controller: emailContr,
                                large: false,
                                enabled:
                                    widget.edit || widget.isSelf ? false : true,
                                autovalidateMode: autoValidate
                                    ? AutovalidateMode.onUserInteraction
                                    : AutovalidateMode.disabled,
                                validationLogic: (value) {
                                  const regex =
                                      r'^[\w\.-]+(\+[\w\.-]+)?@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,}$';
                                  if (value!.isEmpty) {
                                    return 'Please enter your email address';
                                  } else if (!RegExp(regex).hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            const AsteriskLabel(label: 'Member Address'),
                            const SizedBox(height: 8),
                            CustomTextField(
                              hintText: 'Enter address',
                              keyboardType: TextInputType.streetAddress,
                              controller: memberAddressContr,
                              large: true,
                              enabled: true,
                              autovalidateMode: autoValidate
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                              validationLogic: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            const AsteriskLabel(label: 'Country'),
                            const SizedBox(height: 8),
                            MultiSelectFormField(
                              controller: countryContr,
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
                            const SizedBox(height: 16),
                            const AsteriskLabel(label: 'State'),
                            const SizedBox(height: 8),
                            CustomTextField(
                              hintText: 'Type here...',
                              keyboardType: TextInputType.name,
                              controller: stateContr,
                              large: false,
                              enabled: true,
                              autovalidateMode: autoValidate
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                              validationLogic: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter state';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            const AsteriskLabel(label: 'City'),
                            const SizedBox(height: 8),
                            CustomTextField(
                              hintText: 'Type here...',
                              keyboardType: TextInputType.name,
                              controller: cityContr,
                              large: false,
                              enabled: true,
                              autovalidateMode: autoValidate
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                              validationLogic: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter city';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            const AsteriskLabel(label: 'Postal code'),
                            const SizedBox(height: 8),
                            CustomTextField(
                              hintText: 'Enter postal code',
                              keyboardType: TextInputType.number,
                              controller: postalCodeContr,
                              large: false,
                              enabled: true,
                              autovalidateMode: autoValidate
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                              validationLogic: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your postal code';
                                } else if (value.length > 6 ||
                                    value.length < 6) {
                                  return 'Please enter 6 digits postal code';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: Dimension.d10,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (memberStore.isAddOrEditLoading)
              const Material(
                color: Colors.transparent,
                child: LoadingWidget(),
              ),
          ],
        );
      },
    );
  }

  void _initializeControllers() {
    _member = memberStore.activeMember!;
    selectedGenderIndex =
        _genderItems.indexWhere((element) => element.value == _member.gender);
    firstNameContr.text = _member.firstName;
    lastNameContr.text = _member.lastName;
    dobContr.text = DateFormat('dd/MM/yyyy').format(_member.dateOfBirth);
    relationIndex = _relationList
        .indexWhere((element) => element.value == _member.relation);
    if (relationIndex == -1) {
      relationIndex = null;
    }

    phoneNumberContr.text = _member.phoneNumber;
    emailContr.text = _member.email;
    if (_member.profileImg != null) {
      isAlreadyhaveProfileImg = true;
      profileImgUrl = _member.profileImg!.url;
    }
    if (_member.address != null) {
      stateContr.text = _member.address!.state;
      cityContr.text = _member.address!.city;
      memberAddressContr.text = _member.address!.streetAddress;
      _selectedCountryIndex = _countryItems.indexWhere(
        (element) => element.value == _member.address!.country,
      );
      postalCodeContr.text = _member.address!.postalCode;
    }
  }

  void _initializeSelfMemberControllers() {
    final user = GetIt.I<UserDetailStore>().userDetails;
    selectedGenderIndex =
        _genderItems.indexWhere((element) => element.value == user!.gender);
    firstNameContr.text = user!.firstName;
    lastNameContr.text = user.lastName;
    dobContr.text = DateFormat('dd/MM/yyyy').format(user.dateOfBirth);
    relationIndex =
        _relationList.indexWhere((element) => element.value == user.relation);
    if (relationIndex == -1) {
      relationIndex = null;
    }

    phoneNumberContr.text = user.phoneNumber;
    emailContr.text = user.email;
    if (user.profileImg != null) {
      isAlreadyhaveProfileImg = true;
      profileImgUrl = user.profileImg!.url;
    }
    if (user.address != null) {
      stateContr.text = user.address!.state;
      cityContr.text = user.address!.city;
      memberAddressContr.text = user.address!.streetAddress;
      _selectedCountryIndex = _countryItems.indexWhere(
        (element) => element.value == user.address!.country,
      );
      postalCodeContr.text = user.address!.postalCode;
    }
  }
}

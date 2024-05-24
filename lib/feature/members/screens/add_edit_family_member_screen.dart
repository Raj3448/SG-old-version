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
import 'package:silver_genie/core/widgets/asterisk_label.dart';
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/form_components.dart';
import 'package:silver_genie/core/widgets/info_dialog.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/multidropdown.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/members/model/member_model.dart';
import 'package:silver_genie/feature/members/repo/member_service.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';
import 'package:silver_genie/feature/members/widgets/pic_dialogs.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';

class AddEditFamilyMemberScreen extends StatefulWidget {
  const AddEditFamilyMemberScreen({
    required this.edit,
    super.key,
  });

  final bool edit;

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
  final countryContr = TextEditingController();
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
  final List<ValueItem<String>> _relationList = [
    ValueItem(label: 'Father'.tr(), value: 'Father'),
    ValueItem(label: 'Mother'.tr(), value: 'Mother'),
    ValueItem(label: 'Sister'.tr(), value: 'Sister'),
    ValueItem(label: 'Brother'.tr(), value: 'Brother'),
    ValueItem(label: 'Daughter'.tr(), value: 'Daughter'),
    ValueItem(label: 'Son'.tr(), value: 'Son'),
    ValueItem(label: 'Wife'.tr(), value: 'Wife'),
    ValueItem(label: 'Self'.tr(), value: 'Self'),
  ];
  late Member _member;
  late final int? selectedGenderIndex;
  late final int? relationIndex;
  String? profileImgUrl;
  File? storeImageFile;
  bool isImageUpdate = false;

  bool isAlreadyhaveProfileImg = false;

  void _updateImageFile(File? imageFile) {
    storeImageFile = imageFile;
    isImageUpdate = true;
  }

  @override
  void initState() {
    super.initState();

    if (widget.edit) {
      _initializeControllers();
    }
    reaction((_) => memberStore.addNewMemberFailure, (_) {
      if (memberStore.addNewMemberFailure != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(memberStore.addNewMemberFailure!),
          duration: const Duration(seconds: 3),
        ));
        memberStore.addNewMemberFailure = null;
      }
    });

    reaction((_) => memberStore.addNewMemberSuccessfully, (successValue) async {
      if (successValue == null) return;

      await showDialog(
        context: context,
        builder: (context) {
          return InfoDialog(
            showIcon: true,
            title: successValue,
            desc:
                'New family member successfully\nadded to the Health profile.',
            btnTitle: 'Continue',
            showBtnIcon: false,
            btnIconPath: AppIcons.check,
          );
        },
      );

      /// Refreshing the member store, name there can get updated
      GetIt.I<MembersStore>().refresh();
      context.pop();
      memberStore.addNewMemberSuccessfully = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Observer(
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
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: widget.edit
                    ? FixedButton(
                        ontap: () {},
                        btnTitle: 'Save details',
                        showIcon: false,
                        iconPath: AppIcons.check,
                      )
                    : FixedButton(
                        ontap: () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          final genderSelectedValue =
                              genderContr.selectedOptions.first;
                          final relationSelectedValue =
                              relationContr.selectedOptions.first;

                          print(relationSelectedValue == 'Self' ? true : false);
                          print(relationSelectedValue);
                          print(genderSelectedValue);
                          print(firstNameContr.text);
                          print(lastNameContr.text);
                          print(dobContr.text);
                          print(emailContr.text);
                          print(phoneNumberContr.text);
                          memberStore.addNewFamilyMember(
                            address: Address(
                                id: -1,
                                state: stateContr.text.trim(),
                                city: cityContr.text.trim(),
                                streetAddress: memberAddressContr.text.trim(),
                                postalCode: postalCodeContr.text.trim(),
                                country: countryContr.text.trim()),
                            dob: dobContr.text,
                            email: emailContr.text.trim(),
                            firstName: firstNameContr.text.trim(),
                            gender: genderSelectedValue.value.toString().trim(),
                            lastName: lastNameContr.text.trim(),
                            phoneNumber: '91 ${phoneNumberContr.text.trim()}',
                            relation:
                                relationSelectedValue.value.toString().trim(),
                            self:
                                relationSelectedValue.value.toString().trim() ==
                                        'Self'
                                    ? true
                                    : false,
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
                        Center(
                            child: EditPic(
                          onImageSelected: _updateImageFile,
                          imgUrl: profileImgUrl,
                        )),
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
                                enabled: true,
                                onChanged: (value) =>
                                    firstNameContr.text = value,
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
                                enabled: true,
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
                                selectedOptions: widget.edit
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
                                selectedOptions: widget.edit
                                    ? [_relationList[relationIndex!]]
                                    : null,
                                controller: relationContr,
                                values: _relationList,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select the relation';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              const AsteriskLabel(label: 'Mobile number'),
                              const SizedBox(height: 8),
                              CustomTextField(
                                hintText: 'Enter mobile number',
                                keyboardType: TextInputType.number,
                                controller: phoneNumberContr,
                                large: false,
                                enabled: true,
                                validationLogic: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your mobile number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              const AsteriskLabel(label: 'Email ID'),
                              const SizedBox(height: 8),
                              CustomTextField(
                                hintText: 'Enter email address',
                                keyboardType: TextInputType.emailAddress,
                                controller: emailContr,
                                large: false,
                                enabled: true,
                                validationLogic: (value) {
                                  const regex =
                                      r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,}$';
                                  if (value!.isEmpty) {
                                    return 'Please enter your email address';
                                  } else if (!RegExp(regex).hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              const AsteriskLabel(label: 'Member Address'),
                              const SizedBox(height: 8),
                              CustomTextField(
                                hintText: 'Enter address',
                                keyboardType: TextInputType.streetAddress,
                                controller: memberAddressContr,
                                // initialValue: _member.address,
                                large: true,
                                enabled: true,
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
                              CustomTextField(
                                hintText: 'Type here...',
                                keyboardType: TextInputType.name,
                                controller: countryContr,
                                large: false,
                                enabled: true,
                                validationLogic: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your country';
                                  }
                                  return null;
                                },
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
                                validationLogic: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter postal code';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: Dimension.d20),
                        const SizedBox(height: Dimension.d5),
                      ],
                    ),
                  ),
                ),
              ),
              if (memberStore.isAddOrEditLoading)
                const Material(
                    color: Colors.transparent, child: LoadingWidget())
            ],
          );
        },
      ),
    );
  }

  void _initializeControllers() {
    _member = memberStore.activeMember!;
    selectedGenderIndex =
        _genderItems.indexWhere((element) => element.value == _member.gender);
    firstNameContr.text = _member.firstName;
    lastNameContr.text = _member.lastName;
    dobContr.text = DateFormat('yyyy-MM-dd').format(_member.dateOfBirth);
    print(_member.relation);
    relationIndex = _relationList
        .indexWhere((element) => element.value == _member.relation);
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
      countryContr.text = _member.address!.country;
      postalCodeContr.text = _member.address!.postalCode;
    }
  }
}

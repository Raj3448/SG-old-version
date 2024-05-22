// ignore_for_file: deprecated_member_use, inference_failure_on_function_invocation, lines_longer_than_80_chars, strict_raw_type, avoid_bool_literals_in_conditional_expressions

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes.dart';
import 'package:silver_genie/core/widgets/asterisk_label.dart';
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/form_components.dart';
import 'package:silver_genie/core/widgets/info_dialog.dart';
import 'package:silver_genie/core/widgets/multidropdown.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/members/model/member_model.dart';
import 'package:silver_genie/feature/members/repo/member_service.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';
import 'package:silver_genie/feature/members/widgets/pic_dialogs.dart';

class AddEditFamilyMemberScreen extends StatefulWidget {
  const AddEditFamilyMemberScreen(
      {required this.edit, required this.memberId, super.key});

  final bool edit;
  final int memberId;

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

  late MembersStore _memberStore;
  late Member _member;

  final List<ValueItem<String>> _genderItems = [
    const ValueItem(label: 'Male', value: 'Male'),
    const ValueItem(label: 'Female', value: 'Female'),
    const ValueItem(label: 'Other', value: 'Other'),
  ];

  void initController() {
    _memberStore = GetIt.I<MembersStore>();
    _member = _memberStore.members
        .firstWhere((member) => member.id == widget.memberId);
    final selectedGenderIndex = _member.gender == 'Male'
        ? 0
        : _member.gender == 'Female'
            ? 1
            : 2;
    firstNameContr.text = _member.firstName;
    lastNameContr.text = _member.lastName;
    try {
      genderContr.setSelectedOptions([_genderItems[selectedGenderIndex]]);
    } catch (e) {
      print(e);
    }
    dobContr.text = DateFormat('yyyy-MM-dd').format(_member.dateOfBirth);
    // relationContr.setSelectedOptions(options)
    phoneNumberContr.text = _member.phoneNumber;
    emailContr.text = _member.email;
  }

  @override
  Widget build(BuildContext context) {
    initController();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PageAppbar(
        title:
            widget.edit ? 'Member details'.tr() : 'Add new family member'.tr(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: widget.edit
          ? FixedButton(
              ontap: () {
                print(firstNameContr.text);
                print(lastNameContr.text);
                print(genderContr.value);
                print(dobContr.text);
                print(phoneNumberContr.text);
                print(emailContr.text);
                // GoRouter.of(context).pop();
              },
              btnTitle: 'Save details',
              showIcon: false,
              iconPath: AppIcons.check,
            )
          : FixedButton(
              ontap: () async {
                final genderSelectedValue =
                    genderContr.selectedOptions.isNotEmpty
                        ? genderContr.selectedOptions[0].value.toString()
                        : '';
                final relationSelectedValue =
                    relationContr.selectedOptions.isNotEmpty
                        ? relationContr.selectedOptions[0].value.toString()
                        : '';
                if (formKey.currentState!.validate()) {
                  final result = await memberService.addMember(
                    relationSelectedValue == 'Self' ? true : false,
                    relationSelectedValue,
                    genderSelectedValue,
                    firstNameContr.text,
                    lastNameContr.text,
                    dobContr.text,
                    emailContr.text,
                    '91 ${phoneNumberContr.text}',
                  );

                  result.fold(
                    (l) {
                      print('Failure message: $l');
                      l.maybeWhen(
                        validationError: (message) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                            ),
                          );
                        },
                        badResponse: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Bad response from server'),
                            ),
                          );
                        },
                        orElse: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Something Went wrong',
                              ),
                            ),
                          );
                        },
                      );
                    },
                    (r) {
                      print('Member added success');
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
                  );
                }
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
                  storedProfileImage: null,
                  imgUrl: null,
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
                      initialValue: _member.firstName,
                      keyboardType: TextInputType.name,
                      controller: firstNameContr,
                      large: false,
                      enabled: true,
                      onChanged: (value) => firstNameContr.text = value,
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
                      initialValue: _member.lastName,
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
                    GenderDropdown(controller: genderContr),
                    const SizedBox(height: 16),
                    const AsteriskLabel(label: 'Date of birth'),
                    const SizedBox(height: 8),
                    DateDropdown(controller: dobContr),
                    const SizedBox(height: 16),
                    const AsteriskLabel(label: 'Relation'),
                    const SizedBox(height: 8),
                    RelationDropdown(controller: relationContr),
                    const SizedBox(height: 16),
                    const AsteriskLabel(label: 'Mobile number'),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: 'Enter mobile number',
                      keyboardType: TextInputType.number,
                      controller: phoneNumberContr,
                      initialValue: _member.phoneNumber,
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
                      initialValue: _member.email,
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
                    const TextLabel(title: 'Member address'),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: 'Enter address',
                      keyboardType: TextInputType.streetAddress,
                      controller: memberAddressContr,
                      // initialValue: _member.address,
                      large: true,
                      enabled: true,
                    ),
                    const SizedBox(height: 16),
                    const AsteriskLabel(label: 'Country'),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: 'Type here...',
                      keyboardType: TextInputType.number,
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
                    const TextLabel(title: 'State'),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: 'Type here...',
                      keyboardType: TextInputType.number,
                      controller: stateContr,
                      large: false,
                      enabled: true,
                    ),
                    const SizedBox(height: 16),
                    const TextLabel(title: 'City'),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: 'Type here...',
                      keyboardType: TextInputType.number,
                      controller: cityContr,
                      large: false,
                      enabled: true,
                    ),
                    const SizedBox(height: 16),
                    const TextLabel(title: 'Postal code'),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: 'Enter postal code',
                      keyboardType: TextInputType.number,
                      controller: postalCodeContr,
                      large: false,
                      enabled: true,
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
    );
  }

  // void _initializeController(MembersStore store) {
  //   store.members.map((memberDetails) {
  //     firstNameContr.text = memberDetails.firstName;
  //     print(memberDetails.firstName);
  //   });
  // }
}

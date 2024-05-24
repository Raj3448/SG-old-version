// ignore_for_file: public_member_api_docs, sort_constructors_first, lines_longer_than_80_chars, inference_failure_on_function_invocation
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/utils/calculate_age.dart';
import 'package:silver_genie/core/widgets/assigning_component.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/error_state_component.dart';
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/icon_title_details_component.dart';
import 'package:silver_genie/core/widgets/info_dialog.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/members/model/epr_models.dart';
import 'package:silver_genie/feature/members/repo/member_service.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';
import 'package:silver_genie/feature/user_profile/store/user_details_store.dart';

class EPRViewScreen extends StatelessWidget {
  EPRViewScreen({required this.memberId, super.key});
  final store = GetIt.I<UserDetailStore>();

  final String memberId;

  @override
  Widget build(BuildContext context) {
    if (memberId.isEmpty) {
      return const SafeArea(
        child: Scaffold(
          body: ErrorStateComponent(
            errorType: ErrorType.pageNotFound,
          ),
        ),
      );
    }
    return Observer(
      builder: (context) {
        return Scaffold(
          appBar: const PageAppbar(title: 'EPR'),
          backgroundColor: AppColors.white,
          body: FutureBuilder(
            future: GetIt.I<MemberServices>().getEPRData(memberId: memberId),
            builder: (context, snapshot) {
              if (store.isLoadingUserInfo ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingWidget(
                  showShadow: false,
                );
              }

              if (!snapshot.hasData || snapshot.hasError) {
                return const ErrorStateComponent(
                    errorType: ErrorType.somethinWentWrong);
              }

              final data = snapshot.data!;
              final userDetails =
                  GetIt.I<MembersStore>().memberById(int.tryParse(memberId));

              if (userDetails == null) {
                return const ErrorStateComponent(
                    errorType: ErrorType.somethinWentWrong);
              }

              final userInfo = userDetails;

              if (data.isLeft()) {
                final failure = data
                    .getLeft()
                    .getOrElse(() => throw 'error, in calling data.getLeft()');

                final NoEprRecordCase =
                    failure.whenOrNull(memberDontHaveEPRInfo: () => true);

                if (NoEprRecordCase ?? false) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Dimension.d3),
                    child: _PersonalDetailsComponent(
                      name: userInfo.name,
                      email: userInfo.email,
                      phoneNumber: userInfo.phoneNumber,
                      relation: userInfo.relation,
                      dateOfBirth: userInfo.dateOfBirth,
                    ),
                  );
                }

                return const ErrorStateComponent(
                    errorType: ErrorType.somethinWentWrong);
              }

              final EprDataModel eprData = data.getOrElse((l) => throw 'Error');

              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: Dimension.d3),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _PersonalDetailsComponent(
                              name: userInfo.name,
                              email: userInfo.email,
                              phoneNumber: userInfo.phoneNumber,
                              relation: userInfo.relation,
                              dateOfBirth: userInfo.dateOfBirth,
                            ),
                            const SizedBox(
                              height: Dimension.d3,
                            ),
                            _ExpandedButton(
                              title: 'Insurance details',
                              userInsurance: eprData.userInsurance,
                            ),
                            _ExpandedButton(
                                title: 'Preferred Hospitals',
                                preferredServices:
                                    eprData.getPreferredHospital),
                            _ExpandedButton(
                                title: 'Emergency Contact',
                                emrgencyContactList: eprData.emergencyContacts),
                            _ExpandedButton(
                                title: 'Preferred Ambulance',
                                preferredServices:
                                    eprData.getPreferredAmbulace),
                            const SizedBox(
                              height: Dimension.d19,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FixedButton(
            ontap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const InfoDialog(
                    showIcon: false,
                    title: 'Hi there!!',
                    desc:
                        'In order to update the Health record\nof a family member, please contact\nSilvergenie',
                    btnTitle: 'Contact Genie',
                    showBtnIcon: true,
                    btnIconPath: AppIcons.phone,
                  );
                },
              );
            },
            btnTitle: 'Update EPR',
            showIcon: false,
            iconPath: AppIcons.add,
          ),
        );
      },
    );
  }
}

class _PersonalDetailsComponent extends StatelessWidget {
  const _PersonalDetailsComponent({
    super.key,
    required this.email,
    required this.phoneNumber,
    this.streetAddress,
    required this.name,
    this.relation,
    required this.dateOfBirth,
  });
  final String email;
  final String phoneNumber;
  final String? streetAddress;
  final String? relation;
  final String name;
  final DateTime dateOfBirth;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Details',
          style: AppTextStyle.bodyLargeMedium.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            height: 2,
            color: AppColors.grayscale900,
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 3,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: AppColors.grayscale300,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Avatar.fromSize(
                      imgPath: '',
                      size: AvatarSize.size24,
                    ),
                    const SizedBox(
                      width: Dimension.d2,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: AppTextStyle.bodyLargeMedium.copyWith(
                            color: AppColors.grayscale900,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Relation: ${relation ?? "Self"}  Age: ${calculateAge(dateOfBirth)}',
                          style: AppTextStyle.bodyMediumMedium.copyWith(
                            color: AppColors.grayscale800,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: Dimension.d4,
                ),
                IconTitleDetailsComponent(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  details: email,
                ),
                const SizedBox(
                  height: Dimension.d1,
                ),
                IconTitleDetailsComponent(
                  icon: Icons.phone_outlined,
                  title: 'Contact',
                  details: phoneNumber,
                ),
                if (streetAddress != null) ...[
                  const SizedBox(
                    height: Dimension.d4,
                  ),
                  IconTitleDetailsComponent(
                    icon: AppIcons.home,
                    title: 'Address',
                    details: streetAddress ?? '---',
                  ),
                ]
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ExpandedButton extends StatefulWidget {
  const _ExpandedButton({
    required this.title,
    this.emrgencyContactList,
    this.userInsurance,
    this.preferredServices,
    Key? key,
  }) : super(key: key);
  final List<EmergencyContact>? emrgencyContactList;
  final List<UserInsurance>? userInsurance;
  final List<PreferredService>? preferredServices;
  final String title;

  @override
  State<_ExpandedButton> createState() => _ExpandedButtonState();
}

class _ExpandedButtonState extends State<_ExpandedButton> {
  bool _isExpand = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpand = !_isExpand;
            });
          },
          child: SizedBox(
            height: 40,
            child: Row(
              children: [
                Text(
                  widget.title,
                  style: AppTextStyle.bodyLargeMedium.copyWith(
                    height: 2.4,
                    color: AppColors.grayscale900,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: Dimension.d5),
                  child: Icon(
                    _isExpand ? AppIcons.arrow_up_ios : AppIcons.arrow_down_ios,
                    size: 8,
                    color: AppColors.grayscale900,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isExpand)
          const SizedBox(
            height: Dimension.d2,
          ),
        if (_isExpand)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grayscale300),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: List.generate(
                widget.userInsurance != null
                    ? widget.userInsurance!.length
                    : widget.emrgencyContactList != null
                        ? widget.emrgencyContactList!.length
                        : widget.preferredServices!.length,
                (index) => (widget.userInsurance != null)
                    ? _UserInsuranceComponent(
                        titleName:
                            '${index + 1}. ${widget.userInsurance![index].contactPerson}',
                        assignedElements: widget.userInsurance![index],
                      )
                    : (widget.preferredServices != null)
                        ? _PreferredServiceComponent(
                            titleName:
                                '${index + 1}. ${widget.preferredServices![index].name}',
                            assignedElements: widget.preferredServices![index],
                          )
                        : _EmergencyContactComponent(
                            titleName:
                                '${index + 1}. ${widget.emrgencyContactList![index].contactPersonName}',
                            assignedElements:
                                widget.emrgencyContactList![index],
                          ),
              ),
            ),
          ),
        if (!_isExpand) const Divider(),
      ],
    );
  }
}

class _UserInsuranceComponent extends StatelessWidget {
  final String titleName;

  const _UserInsuranceComponent({
    required this.titleName,
    required this.assignedElements,
    Key? key,
  }) : super(key: key);

  final UserInsurance assignedElements;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleName,
            style: AppTextStyle.bodyLargeMedium
                .copyWith(fontWeight: FontWeight.w500, height: 2.4),
          ),
          AssigningComponent(
              name: 'Policy No',
              initializeElement: assignedElements.policyNumber!),
          AssigningComponent(
            name: 'Contact Person',
            initializeElement: assignedElements.contactPerson!,
          ),
          AssigningComponent(
            name: 'Contact Of Ambulance',
            initializeElement: assignedElements.contactNumber!,
          ),
          AssigningComponent(
            name: 'Contact Of Address',
            initializeElement: assignedElements.insuranceProvider!,
          ),
          const Divider(
            color: AppColors.grayscale300,
          ),
        ],
      ),
    );
  }
}

class _EmergencyContactComponent extends StatelessWidget {
  final String titleName;

  const _EmergencyContactComponent({
    required this.titleName,
    required this.assignedElements,
    Key? key,
  }) : super(key: key);

  final EmergencyContact assignedElements;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleName,
            style: AppTextStyle.bodyLargeMedium
                .copyWith(fontWeight: FontWeight.w500, height: 2.4),
          ),
          AssigningComponent(
            name: 'Contact No.',
            initializeElement: assignedElements.contactNumber!,
          ),
          AssigningComponent(
            name: 'Relation',
            initializeElement: assignedElements.relation as String,
          ),
          AssigningComponent(
            name: 'Email',
            initializeElement: assignedElements.email!,
          ),
          AssigningComponent(
            name: 'Contact Of Address',
            initializeElement: assignedElements.country!,
          ),
          const Divider(
            color: AppColors.grayscale300,
          ),
        ],
      ),
    );
  }
}

class _PreferredServiceComponent extends StatelessWidget {
  final String titleName;

  const _PreferredServiceComponent({
    required this.titleName,
    required this.assignedElements,
    Key? key,
  }) : super(key: key);

  final PreferredService assignedElements;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleName,
            style: AppTextStyle.bodyLargeMedium
                .copyWith(fontWeight: FontWeight.w500, height: 2.4),
          ),
          AssigningComponent(
            name: 'Contact Person',
            initializeElement: assignedElements.contactPerson!,
          ),
          AssigningComponent(
            name: 'Contact No.',
            initializeElement: assignedElements.contactNumber!,
          ),
          AssigningComponent(
            name: 'Contact Of Ambulance',
            initializeElement: assignedElements.ambulanceContact != null
                ? assignedElements.ambulanceContact as String
                : 'N/A',
          ),
          const Divider(
            color: AppColors.grayscale300,
          ),
        ],
      ),
    );
  }
}

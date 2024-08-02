// ignore_for_file: public_member_api_docs, sort_constructors_first, lines_longer_than_80_chars, inference_failure_on_function_invocation, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes.dart';
import 'package:silver_genie/core/utils/calculate_age.dart';
import 'package:silver_genie/core/utils/launch_dialer.dart';
import 'package:silver_genie/core/widgets/active_plan.dart';
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
      return const Scaffold(
        body: ErrorStateComponent(
          errorType: ErrorType.pageNotFound,
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
                  errorType: ErrorType.somethinWentWrong,
                );
              }

              final data = snapshot.data!;
              final userDetails =
                  GetIt.I<MembersStore>().memberById(int.tryParse(memberId));

              if (userDetails == null) {
                return const ErrorStateComponent(
                  errorType: ErrorType.somethinWentWrong,
                );
              }

              final userInfo = userDetails;

              if (data.isLeft()) {
                final failure = data.getLeft().getOrElse(
                      () => throw 'error, in calling data.getLeft()',
                    );

                final NoEprRecordCase =
                    failure.whenOrNull(memberDontHaveEPRInfo: () => true);

                if (NoEprRecordCase ?? false) {
                  return Padding(
                    padding: const EdgeInsets.all(Dimension.d3),
                    child: _PersonalDetailsComponent(
                      name: userInfo.name,
                      email: userInfo.email,
                      phoneNumber: userInfo.phoneNumber,
                      relation: userInfo.relation,
                      dateOfBirth: userInfo.dateOfBirth,
                      streetAddress: userInfo.fullAddress,
                    ),
                  );
                }

                return const ErrorStateComponent(
                  errorType: ErrorType.somethinWentWrong,
                );
              }

              final eprData = data.getOrElse((l) => throw 'Error');

              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimension.d4,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: Dimension.d7),
                            _PersonalDetailsComponent(
                              name: userInfo.name,
                              email: userInfo.email,
                              phoneNumber: userInfo.phoneNumber,
                              relation: userInfo.relation,
                              dateOfBirth: userInfo.dateOfBirth,
                              streetAddress: userInfo.fullAddress,
                            ),
                            if (eprData.userInsurance.isNotEmpty)
                              _ExpandedButton(
                                title: 'Insurance details',
                                userInsurance: eprData.userInsurance,
                              ),
                            if (eprData.getPreferredHospital.isNotEmpty)
                              _ExpandedButton(
                                title: 'Preferred Hospitals',
                                preferredServices: eprData.getPreferredHospital,
                              ),
                            if (eprData.emergencyContacts.isNotEmpty)
                              _ExpandedButton(
                                title: 'Emergency Contact',
                                emrgencyContactList: eprData.emergencyContacts,
                              ),
                            if (eprData.getPreferredAmbulace.isNotEmpty)
                              _ExpandedButton(
                                title: 'Preferred Ambulance',
                                preferredServices: eprData.getPreferredAmbulace,
                              ),
                            const SizedBox(height: Dimension.d19),
                            const SizedBox(height: Dimension.d10),
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
                  return InfoDialog(
                    showIcon: false,
                    title: 'Hi there!!',
                    desc:
                        'In order to update the Health record\nof a family member, please contact\nSilvergenie',
                    btnTitle: 'Contact Genie',
                    showBtnIcon: true,
                    btnIconPath: AppIcons.phone,
                    onTap: () {
                      launchDialer(
                        homeStore.getMasterDataModel?.masterData.contactUs
                                .contactNumber ??
                            '',
                      ).then(
                        (value) => GoRouter.of(context).pop(),
                      );
                    },
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
    required this.email,
    required this.phoneNumber,
    required this.name,
    required this.dateOfBirth,
    this.relation,
    this.streetAddress,
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
          style: AppTextStyle.bodyXLBold.copyWith(
            color: AppColors.grayscale900,
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(
            vertical: 16,
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
              horizontal: 12,
              vertical: 12,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Avatar.fromSize(
                      imgPath: '',
                      size: AvatarSize.size24,
                    ),
                    const SizedBox(width: Dimension.d3),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: AppTextStyle.bodyLargeBold.copyWith(
                            color: AppColors.grayscale900,
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
                const SizedBox(height: Dimension.d5),
                IconTitleDetailsComponent(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  details: email,
                ),
                const SizedBox(height: Dimension.d5),
                IconTitleDetailsComponent(
                  icon: Icons.phone_outlined,
                  title: 'Contact',
                  details: phoneNumber,
                ),
                if (streetAddress != null) ...[
                  const SizedBox(height: Dimension.d5),
                  IconTitleDetailsComponent(
                    icon: AppIcons.home,
                    title: 'Address',
                    details: streetAddress ?? '---',
                    maxLines: 3,
                  ),
                ],
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
  });
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
          child: ColoredBox(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Text(
                    widget.title,
                    style: AppTextStyle.bodyXLMedium.copyWith(
                      color: AppColors.grayscale900,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: Dimension.d5),
                    child: Icon(
                      _isExpand
                          ? AppIcons.arrow_up_ios
                          : AppIcons.arrow_down_ios,
                      size: 8,
                      color: AppColors.grayscale900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isExpand) const SizedBox(height: Dimension.d2),
        if (_isExpand)
          Column(
            children: [
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
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: _UserInsuranceComponent(
                              titleName:
                                  '${index + 1}. ${widget.userInsurance![index].contactPerson}',
                              assignedElements: widget.userInsurance![index],
                              isLast: index == widget.userInsurance!.length - 1,
                            ),
                          )
                        : (widget.preferredServices != null)
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: _PreferredServiceComponent(
                                  titleName:
                                      '${index + 1}. ${widget.preferredServices![index].name}',
                                  assignedElements:
                                      widget.preferredServices![index],
                                  isLast: index ==
                                      widget.preferredServices!.length - 1,
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: _EmergencyContactComponent(
                                  titleName:
                                      '${index + 1}. ${widget.emrgencyContactList![index].contactPersonName}',
                                  assignedElements:
                                      widget.emrgencyContactList![index],
                                  isLast: index ==
                                      widget.emrgencyContactList!.length - 1,
                                ),
                              ),
                  ),
                ),
              ),
              const SizedBox(height: Dimension.d4),
            ],
          ),
        if (!_isExpand) const Divider(color: AppColors.line),
      ],
    );
  }
}

class _UserInsuranceComponent extends StatelessWidget {
  final String titleName;

  const _UserInsuranceComponent({
    required this.titleName,
    required this.assignedElements,
    required this.isLast,
  });

  final UserInsurance assignedElements;
  final bool isLast;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Dimension.d3),
        Text(titleName, style: AppTextStyle.bodyLargeMedium),
        const SizedBox(height: Dimension.d3),
        if (assignedElements.policyNumber != null)
          ExpandedAnalogComponent(
            label: 'Policy No',
            value: assignedElements.policyNumber!,
          ),
        ExpandedAnalogComponent(
          label: 'Contact Person',
          value: assignedElements.contactPerson,
        ),
        ExpandedAnalogComponent(
          label: 'Contact Of Ambulance',
          value: assignedElements.contactNumber,
        ),
        ExpandedAnalogComponent(
          label: 'Contact Of Address',
          value: assignedElements.insuranceProvider,
          maxLines: 3,
        ),
        const SizedBox(height: Dimension.d3),
        if (!isLast)
          const Divider(
            color: AppColors.grayscale300,
          ),
      ],
    );
  }
}

class _EmergencyContactComponent extends StatelessWidget {
  final String titleName;

  const _EmergencyContactComponent({
    required this.titleName,
    required this.assignedElements,
    required this.isLast,
  });

  final EmergencyContact assignedElements;
  final bool isLast;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Dimension.d3),
        Text(titleName, style: AppTextStyle.bodyLargeMedium),
        const SizedBox(height: Dimension.d3),
        ExpandedAnalogComponent(
          label: 'Contact No.',
          value: assignedElements.contactNumber,
        ),
        if (assignedElements.relation != null)
          ExpandedAnalogComponent(
            label: 'Relation',
            value: assignedElements.relation!,
          ),
        ExpandedAnalogComponent(
          label: 'Email',
          value: assignedElements.email,
        ),
        if (assignedElements.country != null)
          ExpandedAnalogComponent(
            label: 'Contact Of Address',
            value: assignedElements.country!,
          ),
        const SizedBox(height: Dimension.d3),
        if (!isLast)
          const Divider(
            color: AppColors.grayscale300,
          ),
      ],
    );
  }
}

class _PreferredServiceComponent extends StatelessWidget {
  final String titleName;

  const _PreferredServiceComponent({
    required this.titleName,
    required this.assignedElements,
    required this.isLast,
  });

  final PreferredService assignedElements;
  final bool isLast;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Dimension.d3),
        Text(
          titleName,
          style: AppTextStyle.bodyLargeMedium,
        ),
        const SizedBox(height: Dimension.d3),
        ExpandedAnalogComponent(
          label: 'Contact Person',
          value: assignedElements.contactPerson,
        ),
        ExpandedAnalogComponent(
          label: 'Contact No.',
          value: assignedElements.contactNumber,
        ),
        if (assignedElements.ambulanceContact != null)
          ExpandedAnalogComponent(
            label: 'Contact Of Ambulance',
            value: assignedElements.ambulanceContact!,
          ),
        const SizedBox(height: Dimension.d3),
        if (!isLast)
          const Divider(
            color: AppColors.grayscale300,
          ),
      ],
    );
  }
}

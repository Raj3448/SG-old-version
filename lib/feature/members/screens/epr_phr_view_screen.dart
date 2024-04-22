// ignore_for_file: public_member_api_docs, sort_constructors_first, lines_longer_than_80_chars
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/icon_title_details_component.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/user_profile/store/user_details_store.dart';

class EPRPHRViewScreen extends StatelessWidget {
  EPRPHRViewScreen({super.key});
  final store = GetIt.I<UserDetailStore>();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: const PageAppbar(title: 'EPR'),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(Dimension.d3),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Details',
                      style: AppTextStyle.bodyLargeMedium.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        height: 2.4,
                        color: AppColors.grayscale900,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 3,
                      ),
                      height: 248,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      store.userDetails!.fullname,
                                      style:
                                          AppTextStyle.bodyLargeMedium.copyWith(
                                        color: AppColors.grayscale900,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Relation: Father  Age: 67',
                                      style: AppTextStyle.bodyMediumMedium
                                          .copyWith(
                                        color: AppColors.grayscale800,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            IconTitleDetailsComponent(
                                icon: Icons.email_outlined,
                                title: 'Email',
                                details: store.userDetails!.emailId),
                            IconTitleDetailsComponent(
                                icon: Icons.phone_outlined,
                                title: 'Contact',
                                details: store.userDetails!.mobileNum),
                            IconTitleDetailsComponent(
                                icon: AppIcons.home,
                                title: 'Address',
                                details: store.userDetails!.address),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: Dimension.d3,
                    ),
                    const _ExpandedButton(
                      title: 'Insurance details',
                    ),
                    const _ExpandedButton(
                      title: 'Preferred Hospitals',
                    ),
                    const _ExpandedButton(
                      title: 'Emergency Contact',
                    ),
                    const _ExpandedButton(
                      title: 'Preferred ambulance',
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 76,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.grayscale100,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -4),
                  color: AppColors.grayscale300,
                  blurRadius: 8,
                ),
              ],
            ),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: Dimension.d3,
              horizontal: Dimension.d5,
            ),
            child: CustomButton(
              ontap: () {},
              title: 'Update EPR',
              showIcon: false,
              iconPath: AppIcons.add,
              size: ButtonSize.normal,
              type: ButtonType.primary,
              expanded: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandedButton extends StatefulWidget {
  const _ExpandedButton({required this.title});

  final String title;

  @override
  State<_ExpandedButton> createState() => _ExpandedButtonState();
}

class _ExpandedButtonState extends State<_ExpandedButton> {
  bool _isExpand = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpand = !_isExpand;
        });
      },
      child: Column(
        children: [
          Row(
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
                padding: const EdgeInsets.only(right: Dimension.d2),
                child: Icon(
                  _isExpand ? AppIcons.arrow_up_ios : AppIcons.arrow_down_ios,
                  size: 8,
                  color: AppColors.grayscale900,
                ),
              ),
            ],
          ),
          if (_isExpand)
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grayscale300),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: List.generate(
                  2,
                  (index) => _InsuranceDetailsComponent(
                    insuranceName:
                        '${index + 1}. Aditya Birla Health insurance',
                    policyNo: 'Aabc@wer.com',
                    contactPerson: '9983457601',
                    contactAmbulance: 'N/A',
                    contactAddress:
                        'No 10 Anna nagar 1 st street, near nehru park, chennai, TamilNadu 600028',
                  ),
                ),
              ),
            ),
          if (!_isExpand) const Divider(),
        ],
      ),
    );
  }
}

class _InsuranceDetailsComponent extends StatelessWidget {
  const _InsuranceDetailsComponent({
    required this.insuranceName,
    required this.policyNo,
    required this.contactPerson,
    required this.contactAmbulance,
    required this.contactAddress,
  });

  final String insuranceName;
  final String policyNo;
  final String contactPerson;
  final String contactAmbulance;
  final String contactAddress;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            insuranceName,
            style: AppTextStyle.bodyLargeMedium
                .copyWith(fontWeight: FontWeight.w500, height: 2.4),
          ),
          _InitializeComponent(name: 'Policy No', initializeElement: policyNo),
          _InitializeComponent(
            name: 'Contact Person',
            initializeElement: contactPerson,
          ),
          _InitializeComponent(
            name: 'Contact Of Ambulance',
            initializeElement: contactAmbulance,
          ),
          _InitializeComponent(
            name: 'Contact Of Address',
            initializeElement: contactAddress,
          ),
          const Divider(
            color: AppColors.grayscale300,
          ),
        ],
      ),
    );
  }
}

class _InitializeComponent extends StatelessWidget {
  const _InitializeComponent({
    required this.name,
    required this.initializeElement,
  });

  final String name;
  final String initializeElement;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            name,
            style: AppTextStyle.bodyMediumMedium
                .copyWith(height: 2, color: AppColors.grayscale900),
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ': ',
                style: AppTextStyle.bodyMediumMedium
                    .copyWith(height: 2, color: AppColors.grayscale900),
              ),
              Expanded(
                child: Text(
                  initializeElement,
                  style: AppTextStyle.bodyMediumMedium
                      .copyWith(height: 2, color: AppColors.grayscale700),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

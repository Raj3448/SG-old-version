// ignore_for_file: inference_failure_on_instance_creation

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/core/widgets/profile_component.dart';
import 'package:silver_genie/core/widgets/profile_nav.dart';
import 'package:silver_genie/feature/user_profile/profile_details.dart';
import 'package:silver_genie/feature/user_profile/store/user_details_store.dart';

class UserProfile extends StatelessWidget {
  UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<UserDetailStore>();
    store.getUserDetails();
    return Observer(
      builder: (context) {
        return Scaffold(
            backgroundColor: AppColors.white,
            appBar: const PageAppbar(title: 'User Profile'),
            body: store.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(Dimension.d4),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Dimension.d1),
                                border: Border.all(
                                  color: AppColors.secondary,
                                  width: 2,
                                )),
                            child: Padding(
                              padding: const EdgeInsets.all(Dimension.d3),
                              child: Column(children: [
                                Row(
                                  children: [
                                    const Avatar(imgPath: '', maxRadius: 44),
                                    const SizedBox(
                                      width: Dimension.d2,
                                    ),
                                    Text(
                                      store.userDetails!
                                          .fold((l) => '', (r) => r.fullname),
                                      style: AppTextStyle.bodyXLSemiBold,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: Dimension.d4,
                                ),
                                CustomTextIcon(
                                    iconpath: AppIcons.phone,
                                    title: store.userDetails!
                                        .fold((l) => '', (r) => r.mobileNum)),
                                const SizedBox(
                                  height: Dimension.d2,
                                ),
                                CustomTextIcon(
                                  iconpath: AppIcons.home,
                                  title: store.userDetails!
                                      .fold((l) => '', (r) => r.emailId),
                                ),
                                const SizedBox(
                                  height: Dimension.d4,
                                ),
                                CustomButton(
                                    ontap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ProfileDetails(),
                                        ),
                                      );
                                    },
                                    title: 'Edit',
                                    showIcon: false,
                                    iconPath: Icons.not_interested,
                                    size: ButtonSize.small,
                                    type: ButtonType.secondary,
                                    expanded: true)
                              ]),
                            ),
                          ),
                          const SizedBox(
                            height: Dimension.d6,
                          ),
                          ProfileNav(
                            title: 'SG+ subscription',
                            onTap: () {
                              context.pushNamed(
                                  RoutesConstants.subscriptionsScreen);
                            },
                          ),
                          ProfileNav(
                            title: 'Emergency subscription',
                            onTap: () {},
                          ),
                          ProfileNav(
                            title: 'About',
                            onTap: () {},
                          ),
                          ProfileNav(
                            title: 'Logout',
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return _LogOutComponent();
                                  });
                            },
                          ),
                        ],
                      ),
                    ),
                  ));
      },
    );
  }
}

class _LogOutComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: Dimension.d4,
      ),
      child: Container(
        height: 180,
        padding:
            const EdgeInsets.symmetric(horizontal: Dimension.d4, vertical: 20),
        decoration: BoxDecoration(
            color: AppColors.grayscale100,
            borderRadius: BorderRadius.circular(Dimension.d2)),
        child: Column(
          children: [
            Text(
              'Logout?',
              style: AppTextStyle.bodyXLMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.grayscale900,
              ),
            ),
            const SizedBox(
              height: Dimension.d2,
            ),
            Text(
              'Are you sure, you want to logout?',
              style: AppTextStyle.bodyLargeMedium.copyWith(
                color: AppColors.grayscale800,
              ),
            ),
            const SizedBox(
              height: Dimension.d6,
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: CustomButton(
                      ontap: () {
                        context.pop();
                      },
                      title: 'Cancel',
                      showIcon: false,
                      iconPath: Icons.not_interested,
                      size: ButtonSize.normal,
                      type: ButtonType.secondary,
                      expanded: true,
                    ),
                  ),
                ),
                const SizedBox(
                  width: Dimension.d2,
                ),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: CustomButton(
                      ontap: () {},
                      title: 'Yes, logout',
                      showIcon: false,
                      iconPath: Icons.not_interested,
                      size: ButtonSize.normal,
                      type: ButtonType.primary,
                      expanded: true,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

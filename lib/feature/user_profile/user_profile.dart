// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: inference_failure_on_instance_creation, inference_failure_on_function_invocation, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/env.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/utils/calculate_age.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/core/widgets/profile_component.dart';
import 'package:silver_genie/core/widgets/profile_nav.dart';
import 'package:silver_genie/feature/auth/auth_store.dart';
import 'package:silver_genie/feature/login-signup/store/verify_otp_store.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';
import 'package:silver_genie/feature/user_profile/profile_details.dart';
import 'package:silver_genie/feature/user_profile/store/user_details_store.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfile extends StatelessWidget {
  final UserDetailStore userDetailStore;
  const UserProfile({
    required this.userDetailStore,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: const PageAppbar(title: 'User Profile'),
          body: userDetailStore.isLoadingUserInfo
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(Dimension.d3),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimension.d1),
                            border: Border.all(
                              color: AppColors.secondary,
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(Dimension.d3),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Avatar(
                                        imgPath: userDetailStore
                                                    .userDetails!.profileImg ==
                                                null
                                            ? ''
                                            : '${Env.serverUrl}${userDetailStore.userDetails!.profileImg!.url}',
                                        maxRadius: 44,
                                        isNetworkImage: userDetailStore
                                                    .userDetails!
                                                    .profileImgUrl ==
                                                null
                                            ? false
                                            : true),
                                    const SizedBox(
                                      width: Dimension.d2,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            userDetailStore.userDetails?.name ??
                                                '',
                                            style: AppTextStyle.bodyXLSemiBold
                                                .copyWith(
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                          ),
                                          Text.rich(TextSpan(children: [
                                            TextSpan(
                                              text:
                                                  'Age: ${calculateAge(userDetailStore.userDetails?.dateOfBirth ?? DateTime.now())}',
                                              style: AppTextStyle
                                                  .bodyMediumMedium
                                                  .copyWith(
                                                      color: AppColors
                                                          .grayscale600),
                                            ),
                                            TextSpan(
                                              text:
                                                  ' Relationship: ${userDetailStore.userDetails!.relation}',
                                              style: AppTextStyle
                                                  .bodyMediumMedium
                                                  .copyWith(
                                                      color: AppColors
                                                          .grayscale600),
                                            )
                                          ]))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: Dimension.d4,
                                ),
                                CustomTextIcon(
                                    iconpath: AppIcons.phone,
                                    title: userDetailStore
                                        .userDetails!.phoneNumber),
                                const SizedBox(
                                  height: Dimension.d4,
                                ),
                                CustomTextIcon(
                                    iconpath: AppIcons.home,
                                    title:
                                        userDetailStore.userDetails!.address ==
                                                null
                                            ? 'N/A'
                                            : userDetailStore.userDetails!
                                                .address!.fullAddress),
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
                                  expanded: true,
                                  iconColor: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: Dimension.d6,
                        ),
                        ProfileNav(
                          title: 'Subscriptions',
                          onTap: () {
                            context.pushNamed(
                              RoutesConstants.subscriptionsScreen,
                            );
                          },
                        ),
                        ProfileNav(
                          title: 'About',
                          onTap: () async {
                            await launchUrl(
                              Uri.parse(
                                  'https://www.yoursilvergenie.com/about-us/'),
                            );
                          },
                        ),
                        ProfileNav(
                          title: 'Logout',
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return _LogOutComponent();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class _LogOutComponent extends StatelessWidget {
  final otpStore = GetIt.I<VerityOtpStore>();
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
          borderRadius: BorderRadius.circular(Dimension.d2),
        ),
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
                      iconColor: AppColors.primary,
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
                      ontap: () {
                        GetIt.I<AuthStore>().logout();
                        GetIt.I<VerityOtpStore>().resetTimer();
                        GoRouter.of(context).go(RoutesConstants.loginRoute);
                      },
                      title: 'Yes, logout',
                      showIcon: false,
                      iconPath: Icons.not_interested,
                      size: ButtonSize.normal,
                      type: ButtonType.primary,
                      expanded: true,
                      iconColor: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

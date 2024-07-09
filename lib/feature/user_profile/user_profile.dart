// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: inference_failure_on_instance_creation, inference_failure_on_function_invocation, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/env.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/utils/calculate_age.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/core/widgets/profile_component.dart';
import 'package:silver_genie/core/widgets/profile_nav.dart';
import 'package:silver_genie/feature/auth/auth_store.dart';
import 'package:silver_genie/feature/login-signup/store/verify_otp_store.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';
import 'package:silver_genie/feature/user_profile/store/user_details_store.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfile extends StatefulWidget {
  final UserDetailStore userDetailStore;
  const UserProfile({
    required this.userDetailStore,
    Key? key,
  }) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late final ReactionDisposer _reactionDisposer1;
  late final ReactionDisposer _reactionDisposer2;

  @override
  void initState() {
    _reactionDisposer1 =
        reaction((_) => authStore.logoutSuccess, (logoutSuccess) {
      if (logoutSuccess) {
        GetIt.I<VerityOtpStore>().resetTimer();
        GoRouter.of(context).goNamed(RoutesConstants.loginRoute);
      }
      authStore.logoutSuccess = false;
    });
    _reactionDisposer2 =
        reaction((_) => authStore.logoutFailure, (logoutFailure) {
      if (logoutFailure != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(logoutFailure),
          duration: const Duration(seconds: 3),
        ));
      }
      authStore.logoutFailure = null;
    });
    super.initState();
  }

  @override
  void dispose() {
    _reactionDisposer1();
    _reactionDisposer2();
    super.dispose();
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
                appBar: const PageAppbar(title: 'User Profile'),
                body: widget.userDetailStore.isLoadingUserInfo
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(Dimension.d3),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(Dimension.d1),
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
                                            imgPath: widget
                                                        .userDetailStore
                                                        .userDetails!
                                                        .profileImg ==
                                                    null
                                                ? ''
                                                : '${Env.serverUrl}${widget.userDetailStore.userDetails!.profileImg!.url}',
                                            maxRadius: 44,
                                            isNetworkImage: widget
                                                        .userDetailStore
                                                        .userDetails!
                                                        .profileImgUrl ==
                                                    null
                                                ? false
                                                : true,
                                          ),
                                          const SizedBox(
                                            width: Dimension.d2,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.userDetailStore
                                                          .userDetails?.name ??
                                                      '',
                                                  style: AppTextStyle
                                                      .bodyXLSemiBold
                                                      .copyWith(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            'Age: ${calculateAge(widget.userDetailStore.userDetails?.dateOfBirth ?? DateTime.now())}',
                                                        style: AppTextStyle
                                                            .bodyMediumMedium
                                                            .copyWith(
                                                          color: AppColors
                                                              .grayscale600,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            ' Relationship: ${widget.userDetailStore.userDetails!.relation}',
                                                        style: AppTextStyle
                                                            .bodyMediumMedium
                                                            .copyWith(
                                                          color: AppColors
                                                              .grayscale600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
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
                                        title: widget.userDetailStore
                                            .userDetails!.phoneNumber,
                                      ),
                                      const SizedBox(
                                        height: Dimension.d4,
                                      ),
                                      CustomTextIcon(
                                        iconpath: AppIcons.home,
                                        title: widget.userDetailStore
                                                    .userDetails!.address ==
                                                null
                                            ? 'N/A'
                                            : widget
                                                .userDetailStore
                                                .userDetails!
                                                .address!
                                                .fullAddress,
                                      ),
                                      const SizedBox(
                                        height: Dimension.d4,
                                      ),
                                      CustomButton(
                                        ontap: () {
                                          context.push(
                                              RoutesConstants.profileDetails);
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
                                      'https://www.yoursilvergenie.com/about-us/',
                                    ),
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
              ),
              if (authStore.isLogoutLoading)
                const Material(
                  color: Colors.transparent,
                  child: LoadingWidget(),
                )
            ],
          );
        },
      ),
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
                        context.pop();
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

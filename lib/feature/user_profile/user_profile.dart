// ignore_for_file: inference_failure_on_instance_creation

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fpdart/fpdart.dart' as fp;
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
import 'package:silver_genie/feature/user_profile/services/user_failure_or_success.dart';
import 'package:silver_genie/feature/user_profile/store/user_details_store.dart';

class UserProfile extends StatelessWidget {
  UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<UserDetailStore>();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PageAppbar(title: 'User Profile'),
      body: FutureBuilder(
        future: store.getUserDetails(),
        builder: (context,
            AsyncSnapshot<fp.Either<UserFailure, UserSuccess>> snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapShot.hasData) {
            return const SizedBox();
          }
          _tempMethod(snapShot.data!);
          return Observer(
            builder: (_) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(Dimension.d4),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimension.d1),
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
                                  store.userDetails!.fullname,
                                  style: AppTextStyle.bodyXLSemiBold,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: Dimension.d4,
                            ),
                            CustomTextIcon(
                                iconpath: AppIcons.phone,
                                title: store.userDetails!.mobileNum),
                            const SizedBox(
                              height: Dimension.d2,
                            ),
                            CustomTextIcon(
                              iconpath: AppIcons.home,
                              title: store.userDetails!.emailId,
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
                        title: 'Wallet',
                        onTap: () {},
                      ),
                      ProfileNav(
                        title: 'SG+ subscription',
                        onTap: () {
                          context
                              .pushNamed(RoutesConstants.subscriptionsScreen);
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
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _tempMethod(fp.Either<UserFailure, UserSuccess> snapshot) {
    snapshot.fold(
      (failure) {
        failure.map(
            socketException: (value) {
              print(value);
            },
            someThingWentWrong: (value) {
              print(value);
            },
            badResponse: (value) {
              print(value);
            });
      },
      (success) {
        print('API call successful $success');
      },
    );
  }
}
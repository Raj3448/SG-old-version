// ignore_for_file: lines_longer_than_80_chars

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/form_components.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/multidropdown.dart';
import 'package:silver_genie/feature/login-signup/services/auth_service.dart';
import 'package:silver_genie/feature/login-signup/store/login_store.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final firstNameContr = TextEditingController();
    final lastNameContr = TextEditingController();
    final emailContr = TextEditingController();
    final phoneNumbContr = TextEditingController();
    final dobContr = TextEditingController();
    final authService = GetIt.I<AuthService>();
    final store = GetIt.I<LoginStore>();
    return Scaffold(
      body: Observer(
        builder: (context) {
          if (store.authFailure != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              print(store.authFailure);
              store.authFailure?.fold(
                (l) => {
                  l.maybeWhen(invalidEmail: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Invalid email!')));
                  }, orElse: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: Unknown error!')));
                  })
                },
                (r) => GoRouter.of(context).pushNamed(
                  RoutesConstants.otpRoute,
                  pathParameters: {
                    'email': emailContr.text,
                    'phoneNumber': phoneNumbContr.text,
                  },
                ),
              );
            });
          }

          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(Dimension.d5),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 52,
                      ),
                      SizedBox(
                        width: 130,
                        height: 60,
                        child: Image.asset('assets/splash/sg_logo.png'),
                      ),
                      const SizedBox(
                        height: Dimension.d7,
                      ),
                      Text(
                        'Sign Up'.tr(),
                        style: AppTextStyle.heading4SemiBold,
                      ),
                      const SizedBox(height: Dimension.d6),
                      Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextLabel(title: 'Enter first name'.tr()),
                            const SizedBox(height: Dimension.d2),
                            CustomTextField(
                              hintText: 'Enter first name'.tr(),
                              keyboardType: TextInputType.name,
                              large: false,
                              enabled: true,
                              controller: firstNameContr,
                              validationLogic: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: Dimension.d4),
                            TextLabel(title: 'Enter last name'.tr()),
                            const SizedBox(height: Dimension.d2),
                            CustomTextField(
                              hintText: 'Enter last name'.tr(),
                              keyboardType: TextInputType.name,
                              large: false,
                              enabled: true,
                              controller: lastNameContr,
                              textInputAction: TextInputAction.next,
                              validationLogic: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: Dimension.d4),
                            TextLabel(title: 'Enter Email'.tr()),
                            const SizedBox(height: Dimension.d2),
                            CustomTextField(
                              hintText: 'Enter E-mail'.tr(),
                              keyboardType: TextInputType.emailAddress,
                              large: false,
                              enabled: true,
                              controller: emailContr,
                              textInputAction: TextInputAction.next,
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
                            const SizedBox(height: Dimension.d4),
                            TextLabel(title: 'Mobile Number'.tr()),
                            const SizedBox(height: Dimension.d2),
                            CustomPhoneField(
                              controller: phoneNumbContr,
                              title: 'Enter Mobile Number'.tr(),
                            ),
                            const SizedBox(height: Dimension.d4),
                            TextLabel(title: 'Date of birth'.tr()),
                            const SizedBox(height: Dimension.d2),
                            DateDropdown(
                              controller: dobContr,
                            ),
                            const SizedBox(height: Dimension.d4),
                            CustomButton(
                              size: ButtonSize.normal,
                              type: ButtonType.primary,
                              expanded: true,
                              ontap: () {
                                if (formKey.currentState!.validate() &&
                                    firstNameContr.text.isNotEmpty) {
                                  store.signup(
                                    firstNameContr.text,
                                    lastNameContr.text,
                                    dobContr.text,
                                    emailContr.text,
                                    '${store.selectCountryDialCode ?? '91'} ${phoneNumbContr.text}'
                                        .replaceFirst('+', ''),
                                    context,
                                  );
                                  // await authService.signup(
                                  //   firstNameContr.text,
                                  //   lastNameContr.text,
                                  //   dobContr.text,
                                  //   emailContr.text,
                                  //   '${store.selectCountryDialCode ?? '91'} ${phoneNumbContr.text}'
                                  //       .replaceFirst('+', ''),
                                  //   context,
                                  // );
                                }
                              },
                              title: 'Sign Up'.tr(),
                              showIcon: false,
                              iconPath: Icons.not_interested,
                              iconColor: AppColors.white,
                            ),
                            const SizedBox(height: Dimension.d6),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?'.tr(),
                            style: AppTextStyle.bodyLargeMedium,
                          ),
                          const SizedBox(
                            width: Dimension.d1,
                          ),
                          CustomButton(
                            size: ButtonSize.normal,
                            type: ButtonType.tertiary,
                            expanded: true,
                            ontap: () {
                              GoRouter.of(context)
                                  .go(RoutesConstants.loginRoute);
                            },
                            title: 'Login'.tr(),
                            showIcon: false,
                            iconPath: Icons.not_interested,
                            iconColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (store.isLoading == true) const LoadingWidget(),
            ],
          );
        },
      ),
    );
  }
}

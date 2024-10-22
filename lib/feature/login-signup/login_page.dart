// ignore_for_file: lines_longer_than_80_chars

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/form_components.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/feature/login-signup/store/login_store.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({required this.redirectRouteName, super.key});
  final String? redirectRouteName;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final store = GetIt.I<LoginStore>();
  final emailFormKey = GlobalKey<FormState>();
  final numberFormKey = GlobalKey<FormState>();
  final phoneNumberContr = TextEditingController();
  final emailContr = TextEditingController();
  bool autoValidate = false;

  @override
  void initState() {
    super.initState();

    reaction((_) => store.authFailure, (authFailure) {
      if (store.authFailure != null && mounted) {
        store.authFailure?.fold(
          (l) {
            l.maybeWhen(
              invalidEmail: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Invalid emailaddress!',
                    ),
                  ),
                );
              },
              userNotFound: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User not found!')),
                );
              },
              orElse: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error: Unknown error!')),
                );
              },
            );
          },
          (r) {
            GoRouter.of(context).pushNamed(
              RoutesConstants.otpRoute,
              extra: {
                'email': emailContr.text,
                'phoneNumber':
                    '${store.selectCountryDialCode ?? '91'} ${phoneNumberContr.text}'
                        .replaceFirst('+', ''),
                'isFromLoginPage': 'true',
                'redirectRouteName': widget.redirectRouteName,
              },
            );
          },
        );
        // Reset the authFailure after handling.
        store.authFailure = null;
      }
    });
  }

  @override
void dispose() {
  phoneNumberContr.dispose();
  emailContr.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.white,
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(Dimension.d5),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/splash/sg_logo.png',
                        width: 240,
                        height: 240,
                        fit: BoxFit.contain,
                      ),
                      Text(
                        'Login'.tr(),
                        style:
                            AppTextStyle.heading4SemiBold.copyWith(height: 1),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? Dimension.d3
                            : Dimension.d6,
                      ),
                      Observer(
                        builder: (context) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextLabel(
                                title: store.isEmail
                                    ? 'Enter email'
                                    : 'Mobile Number'.tr(),
                              ),
                              const SizedBox(height: Dimension.d2),
                              if (store.isEmail)
                                Form(
                                  key: emailFormKey,
                                  child: CustomTextField(
                                    controller: emailContr,
                                    hintText: 'Enter e-mail',
                                    keyboardType: TextInputType.emailAddress,
                                    large: false,
                                    enabled: true,
                                    autovalidateMode: autoValidate
                                        ? AutovalidateMode.onUserInteraction
                                        : AutovalidateMode.disabled,
                                    validationLogic: (value) {
                                      const regex =
                                          r'^[\w\.-]+(\+[\w\.-]+)?@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,}$';
                                      if (value!.isEmpty) {
                                        return 'Please enter your email address';
                                      } else if (!RegExp(regex)
                                          .hasMatch(value)) {
                                        return 'Please enter a valid email address';
                                      }
                                      return null;
                                    },
                                  ),
                                )
                              else
                                Form(
                                  key: numberFormKey,
                                  child: CustomPhoneField(
                                    controller: phoneNumberContr,
                                    title: 'Enter Mobile Number'.tr(),
                                    autovalidate: autoValidate
                                        ? AutovalidateMode.onUserInteraction
                                        : AutovalidateMode.disabled,
                                  ),
                                ),
                              const SizedBox(height: Dimension.d4),
                              CustomButton(
                                size: ButtonSize.large,
                                type: ButtonType.tertiary,
                                expanded: false,
                                ontap: () {
                                  store.isEmail = !store.isEmail;
                                  setState(() {
                                    autoValidate = false;
                                  });
                                },
                                title: store.isEmail
                                    ? 'Use Mobile Number instead'.tr()
                                    : 'Use email instead'.tr(),
                                showIcon: false,
                                iconPath: Icons.not_interested,
                                iconColor: AppColors.white,
                              ),
                              const SizedBox(height: Dimension.d4),
                              SizedBox(
                                width: double.infinity,
                                child: CustomButton(
                                  size: ButtonSize.normal,
                                  type: ButtonType.primary,
                                  expanded: true,
                                  ontap: () async {
                                    setState(() {
                                      autoValidate = true;
                                    });
                                    if (store.isEmail) {
                                      if (emailFormKey.currentState!
                                          .validate()) {
                                        store
                                          ..login(emailContr.text)
                                          ..identifier = emailContr.text;
                                      }
                                    } else {
                                      if (numberFormKey.currentState!
                                          .validate()) {
                                        store
                                          ..login(
                                            '${store.selectCountryDialCode ?? '91'} ${phoneNumberContr.text}'
                                                .replaceFirst('+', ''),
                                          )
                                          ..identifier =
                                              '${store.selectCountryDialCode ?? '91'} ${phoneNumberContr.text}'
                                                  .replaceFirst('+', '');
                                      }
                                    }
                                  },
                                  title: 'Login'.tr(),
                                  showIcon: false,
                                  iconPath: Icons.not_interested,
                                  iconColor: AppColors.white,
                                ),
                              ),
                              const SizedBox(height: Dimension.d6),
                            ],
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?".tr(),
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
                                  .push(RoutesConstants.signUpRoute);
                            },
                            title: 'Signup'.tr(),
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
            ),
            if (store.isLoading)
              const Material(color: Colors.transparent, child: LoadingWidget()),
          ],
        );
      },
    );
  }
}

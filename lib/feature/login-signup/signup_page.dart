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
import 'package:silver_genie/core/widgets/multidropdown.dart';
import 'package:silver_genie/feature/login-signup/store/signup_store.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  final firstNameContr = TextEditingController();
  final lastNameContr = TextEditingController();
  final emailContr = TextEditingController();
  final phoneNumbContr = TextEditingController();
  final dobContr = TextEditingController();
  final store = GetIt.I<SignupStore>();
  bool autoValidate = false;

  @override
  void initState() {
    super.initState();

    reaction((_) => store.authFailure, (authFailure) {
      if (store.authFailure != null && mounted) {
        store.authFailure?.fold(
          (l) => {
            l.maybeWhen(
              invalidEmail: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid email address!')),
                );
              },
              invalidPhoneNumber: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid phone number!')),
                );
              },
              userAlreadyExists: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('User already exists!'),
                  ),
                );
              },
              orElse: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error: Unknown error!')),
                );
              },
            ),
          },
          (r) => GoRouter.of(context).pushNamed(
            RoutesConstants.otpRoute,
            extra: {
              'email': emailContr.text,
              'phoneNumber':
                  '${store.selectCountryDialCode ?? '91'} ${phoneNumbContr.text}'
                      .replaceFirst('+', ''),
              'isFromLoginPage': 'false',
            },
          ),
        );
      }
      store.authFailure = null;
    });
  }

  @override
  void dispose() {
    firstNameContr.dispose();
    lastNameContr.dispose();
    emailContr.dispose();
    phoneNumbContr.dispose();
    dobContr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Observer(
        builder: (context) {
          return OrientationBuilder(
            builder: (context, orientation) {
              final isLandscape = orientation == Orientation.landscape;
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(Dimension.d5),
                      child: Column(
                        children: [
                          SizedBox(
                            height: isLandscape ? Dimension.d2 : 0,
                          ),
                          Image.asset(
                            'assets/splash/sg_logo.png',
                            width: 240,
                            height: 180,
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
                                  autovalidateMode: autoValidate
                                      ? AutovalidateMode.onUserInteraction
                                      : AutovalidateMode.disabled,
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
                                  autovalidateMode: autoValidate
                                      ? AutovalidateMode.onUserInteraction
                                      : AutovalidateMode.disabled,
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
                                  autovalidateMode: autoValidate
                                      ? AutovalidateMode.onUserInteraction
                                      : AutovalidateMode.disabled,
                                  validationLogic: (value) {
                                    const regex =
                                        r'^[\w\.-]+(\+[\w\.-]+)?@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,}$';
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
                                  isSignUpComponent: true,
                                  controller: phoneNumbContr,
                                  title: 'Enter Mobile Number'.tr(),
                                  autovalidate: autoValidate
                                      ? AutovalidateMode.onUserInteraction
                                      : AutovalidateMode.disabled,
                                ),
                                const SizedBox(height: Dimension.d4),
                                TextLabel(title: 'Date of birth'.tr()),
                                const SizedBox(height: Dimension.d2),
                                DateDropdown(
                                  controller: dobContr,
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select the DOB';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: Dimension.d4),
                                CustomButton(
                                  size: ButtonSize.normal,
                                  type: ButtonType.primary,
                                  expanded: true,
                                  ontap: () {
                                    setState(() {
                                      autoValidate = true;
                                    });
                                    if (formKey.currentState!.validate() &&
                                        firstNameContr.text.isNotEmpty) {
                                      final dateObject =
                                DateFormat('dd/MM/yyyy').parse(dobContr.text);
                            final formattedDate =
                                DateFormat('yyyy-MM-dd').format(dateObject);
                                      store
                                        ..signup(
                                          firstNameContr.text,
                                          lastNameContr.text,
                                          formattedDate,
                                          emailContr.text,
                                          '${store.selectCountryDialCode ?? '91'} ${phoneNumbContr.text}'
                                              .replaceFirst('+', ''),
                                        )
                                        ..firstName = firstNameContr.text
                                        ..lastName = lastNameContr.text
                                        ..dob = dobContr.text
                                        ..email = emailContr.text
                                        ..phoneNumber = phoneNumbContr.text;
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
          );
        },
      ),
    );
  }
}

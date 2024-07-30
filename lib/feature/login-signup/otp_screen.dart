// ignore_for_file: lines_longer_than_80_chars

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/feature/auth/auth_store.dart';
import 'package:silver_genie/feature/login-signup/services/auth_service.dart';
import 'package:silver_genie/feature/login-signup/store/login_store.dart';
import 'package:silver_genie/feature/login-signup/store/signup_store.dart';
import 'package:silver_genie/feature/login-signup/store/verify_otp_store.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({
    required this.isFromLoginPage,
    required this.redirectRouteName,
    this.phoneNumber,
    this.email,
    super.key,
  });
  final String? email;
  final String? phoneNumber;
  final bool isFromLoginPage;
  final String? redirectRouteName;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController otpController = TextEditingController();
  final authService = GetIt.I<AuthService>();
  final store = GetIt.I<VerityOtpStore>();
  final loginStore = GetIt.I<LoginStore>();
  final signupStore = GetIt.I<SignupStore>();
  bool autoValidate = false;

  @override
  void initState() {
    super.initState();

    reaction((_) => store.authFailure, (authFailure) {
      if (store.authFailure != null) {
        store.authFailure?.fold(
          (l) => {
            l.maybeWhen(
              invalidOTP: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid OTP!')),
                );
              },
              orElse: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error: Unknown error!')),
                );
              },
            ),
          },
          (r) => {
            GetIt.I<AuthStore>().refresh(),
            if (widget.redirectRouteName != null &&
                widget.redirectRouteName!.isNotEmpty)
              {
                GoRouter.of(context).goNamed(
                  widget.redirectRouteName!,
                  queryParameters: {'skipRootRedirectCheck': 'true'},
                ),
              }
            else
              {
                GoRouter.of(context).goNamed(
                  RoutesConstants.homeRoute,
                  queryParameters: {'skipRootRedirectCheck': 'true'},
                ),
              },
          },
        );
        store.authFailure = null;
      }
    });

    reaction((_) => store.isError, (isError) {
      if (store.isError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid OTP!')),
        );
      }
      store.isError = false;
    });

    store.startTimer();
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    store.startTimer();
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
                      SizedBox(
                        width: 240,
                        height: 240,
                        child: Image.asset('assets/splash/sg_logo.png'),
                      ),
                      Text(
                        'Verify OTP'.tr(),
                        style: AppTextStyle.heading4SemiBold
                            .copyWith(color: AppColors.grayscale900),
                      ),
                      const SizedBox(height: Dimension.d6),
                      Text(
                        widget.isFromLoginPage && loginStore.isEmail
                            ? 'We have just sent you 4 digit code to your email.'
                            : widget.isFromLoginPage
                                ? 'We have just sent you 4 digit code to your phone number.'
                                : 'We have just sent you 4 digit code to your email and phone number.'
                                    .tr(),
                        textAlign: TextAlign.center,
                        style: AppTextStyle.bodyMediumMedium
                            .copyWith(color: AppColors.grayscale700),
                      ),
                      const SizedBox(height: Dimension.d6),
                      Form(
                        key: formKey,
                        child: PinCodeTextField(
                          controller: otpController,
                          appContext: context,
                          autoFocus: true,
                          mainAxisAlignment: MainAxisAlignment.center,
                          enablePinAutofill: false,
                          length: 4,
                          keyboardType: TextInputType.number,
                          cursorColor: AppColors.grayscale900,
                          animationCurve: Curves.easeIn,
                          animationType: AnimationType.fade,
                          enableActiveFill: true,
                          autovalidateMode: autoValidate
                              ? AutovalidateMode.onUserInteraction
                              : AutovalidateMode.disabled,
                          autoDisposeControllers: false,
                          errorTextMargin:
                              const EdgeInsets.only(left: Dimension.d14),
                          separatorBuilder: (context, index) {
                            return const SizedBox(width: Dimension.d4);
                          },
                          errorTextSpace: 25,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(8),
                            fieldHeight: 56,
                            fieldWidth: 56,
                            activeColor: AppColors.primary,
                            inactiveColor: AppColors.line,
                            selectedColor: AppColors.primary,
                            selectedFillColor: AppColors.secondary,
                            activeFillColor: AppColors.secondary,
                            inactiveFillColor: AppColors.white,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your OTP';
                            } else if (value.length > 4 || value.length < 4) {
                              return 'Please enter 4 digits OTP';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: Dimension.d4),
                      CustomButton(
                        size: ButtonSize.normal,
                        type: ButtonType.primary,
                        expanded: true,
                        ontap: () async {
                          autoValidate = true;
                          if (otpController.text.isNotEmpty) {
                            if (widget.isFromLoginPage) {
                              store.verifyOtp(
                                otp: otpController.text,
                                phoneNumber: loginStore.isEmail
                                    ? null
                                    : widget.phoneNumber,
                                email: loginStore.isEmail ? widget.email : null,
                                isFromLoginPage: true,
                              );
                              return;
                            }

                            store.verifyOtp(
                              otp: otpController.text,
                              phoneNumber: widget.phoneNumber,
                              email: widget.email,
                              isFromLoginPage: widget.isFromLoginPage,
                            );
                          }
                        },
                        title: 'Continue'.tr(),
                        showIcon: false,
                        iconPath: Icons.not_interested,
                        iconColor: AppColors.white,
                      ),
                      const SizedBox(height: Dimension.d6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't receive OTP?".tr(),
                            style: AppTextStyle.bodyLargeMedium
                                .copyWith(color: AppColors.grayscale800),
                          ),
                          const SizedBox(
                            width: Dimension.d1,
                          ),
                          Observer(
                            builder: (_) {
                              return store.showResendButton
                                  ? CustomButton(
                                      size: ButtonSize.normal,
                                      type: ButtonType.tertiary,
                                      expanded: true,
                                      ontap: store.isResendLoading
                                          ? () {}
                                          : () {
                                              widget.isFromLoginPage == true
                                                  ? store.resendOTPLogin(
                                                      loginStore.identifier,
                                                    )
                                                  : store.resendOTPSignup(
                                                      signupStore.firstName,
                                                      signupStore.lastName,
                                                      signupStore.dob,
                                                      signupStore.email,
                                                      '${signupStore.selectCountryDialCode ?? '91'} ${signupStore.phoneNumber}'
                                                          .replaceFirst(
                                                        '+',
                                                        '',
                                                      ),
                                                    );
                                            },
                                      title: store.isResendLoading
                                          ? 'Resending'
                                          : 'Resend'.tr(),
                                      showIcon: false,
                                      iconPath: Icons.not_interested,
                                      iconColor: AppColors.white,
                                    )
                                  : CustomButton(
                                      size: ButtonSize.normal,
                                      type: ButtonType.tertiary,
                                      expanded: true,
                                      ontap: () {},
                                      title:
                                          'Resend in ${store.countdown}s'.tr(),
                                      showIcon: false,
                                      iconPath: Icons.not_interested,
                                      iconColor: AppColors.white,
                                    );
                            },
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

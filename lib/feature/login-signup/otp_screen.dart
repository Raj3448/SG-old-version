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
import 'package:silver_genie/feature/login-signup/store/verify_otp_store.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({
    required this.email,
    required this.phoneNumber,
    required this.isFromLoginPage,
    super.key,
  });
  final String email;
  final String phoneNumber;
  final bool isFromLoginPage;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController otpController = TextEditingController();
  final authService = GetIt.I<AuthService>();
  final store = GetIt.I<VerityOtpStore>();

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
            GoRouter.of(context).goNamed(
              RoutesConstants.homeRoute,
            ),
          },
        );

        store.authFailure = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Observer(
        builder: (context) {
          return Stack(
            children: [
              SingleChildScrollView(
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
                        style: AppTextStyle.heading4SemiBold,
                      ),
                      const SizedBox(height: Dimension.d6),
                      Text(
                        'We have just sent you 4 digit code to your email and phone number'
                            .tr(),
                        textAlign: TextAlign.center,
                        style: AppTextStyle.bodyMediumMedium,
                      ),
                      const SizedBox(height: Dimension.d6),
                      Form(
                        key: formKey,
                        child: PinCodeTextField(
                          controller: otpController,
                          appContext: context,
                          mainAxisAlignment: MainAxisAlignment.center,
                          length: 4,
                          keyboardType: TextInputType.number,
                          cursorColor: AppColors.black,
                          animationCurve: Curves.easeIn,
                          animationType: AnimationType.fade,
                          onChanged: (value) {
                            // Handle OTP changes
                          },
                          onCompleted: (value) {
                            // Handle successful OTP entry
                          },
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
                            activeFillColor: AppColors.grayscale900,
                            selectedFillColor: AppColors.secondary,
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
                          if (otpController.text.isNotEmpty) {
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
                            style: AppTextStyle.bodyLargeMedium,
                          ),
                          const SizedBox(
                            width: Dimension.d1,
                          ),
                          CustomButton(
                            size: ButtonSize.normal,
                            type: ButtonType.tertiary,
                            expanded: true,
                            ontap: () {},
                            title: 'Resend'.tr(),
                            showIcon: false,
                            iconPath: Icons.not_interested,
                            iconColor: AppColors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (store.isLoading) const LoadingWidget(),
            ],
          );
        },
      ),
    );
  }
}

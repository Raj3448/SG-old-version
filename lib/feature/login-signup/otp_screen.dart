// ignore_for_file: lines_longer_than_80_chars

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/buttons.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
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
                  errorTextMargin: const EdgeInsets.only(left: Dimension.d14),
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
                ontap: () {
                  if (formKey.currentState!.validate()) {
                    GoRouter.of(context).push(RoutesConstants.mainRoute);
                  }
                },
                title: 'Continue'.tr(),
                showIcon: false,
                iconPath: Icons.not_interested,
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

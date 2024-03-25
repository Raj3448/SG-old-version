import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/widgets/buttons.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});
  static String routeName = '/otp_screen';

  @override
  Widget build(BuildContext context) {
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
              const Text(
                'Verify OTP',
                style: AppTextStyle.heading4SemiBold,
              ),
              const SizedBox(height: Dimension.d6),
              const Text(
                'We have just sent you 4 digit code to your email and phone number',
                textAlign: TextAlign.center,
                style: AppTextStyle.bodyMediumMedium,
              ),
              const SizedBox(height: Dimension.d4),
              PinCodeTextField(
                appContext: context,
                length: 4,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  // Handle OTP changes
                },
                onCompleted: (value) {
                  // Handle successful OTP entry
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 56,
                  fieldWidth: 56,
                  activeColor: Colors.blue,
                  inactiveColor: Colors.grey,
                  selectedColor: Colors.black,
                ),
              ),
              const SizedBox(height: Dimension.d4),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  size: ButtonSize.normal,
                  type: ButtonType.primary,
                  expanded: true,
                  ontap: () {},
                  title: 'Continue',
                  showIcon: false,
                  iconPath: Icons.not_interested,
                ),
              ),
              const SizedBox(height: Dimension.d6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't receive OTP?",
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
                    title: 'Resend',
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

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/widgets/buttons.dart';

// class OTPScreen extends StatelessWidget {
//   //final String phoneNumber;

//   OTPScreen({required this.phoneNumber});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                width: screenWidth * 0.5,
                height: screenHeight * 0.3,
                child: Image.asset('assets/splash/sg_logo.png'),
              ),
              const Text(
                'Verify OTP',
                style: AppTextStyle.heading4SemiBold,
              ),
              SizedBox(height: screenHeight * 0.03),
              const Text(
                'We have just sent you 4 digit code to your email and phone number',
                textAlign: TextAlign.center,
                style: AppTextStyle.bodyMediumMedium,
              ),
              SizedBox(height: screenHeight * 0.03),
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
              SizedBox(height: screenHeight * 0.02),
              SizedBox(
                width: double.infinity,
                child: NormalPrimaryButton(
                  ontap: (){},
                  title: 'Continue',
                  showIcon: false,
                  iconPath: ''),
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't receive OTP?",
                    style: AppTextStyle.bodyLargeMedium,
                  ),
                  SizedBox(
                    width: screenWidth*0.01,
                  ),
                  NormalTertiaryButton(
                    ontap: (){}, 
                    title: "Resend",
                     showIcon: false, 
                     iconPath: '',)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

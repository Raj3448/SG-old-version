import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/form_components.dart';
import 'package:silver_genie/feature/login-signup/login_page.dart';
import 'package:silver_genie/feature/login-signup/otp_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //TextEditingController _mobileController = TextEditingController();
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
                    'Sign Up',
                    style: AppTextStyle.heading4SemiBold,
                  ),
                  SizedBox(height: screenHeight * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InitialLabelForm(
                    title: 'Enter Full Name',
                    hintText: 'Enter Name',
                    keyboardType: TextInputType.name),
                  SizedBox(height: screenHeight * 0.02),
                  InitialLabelForm(
                    title: 'Enter Email',
                    hintText: 'Enter E-mail',
                    keyboardType: TextInputType.emailAddress),
                  SizedBox(height: screenHeight * 0.02),
                  PhoneLableForm(
                    title: 'Enter Mobile Number', text: 'Mobile Number'),
                  SizedBox(height: screenHeight * 0.02),
                  SizedBox(
                    width:double.infinity,
                    child: NormalPrimaryButton(
                      ontap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=>const OTPScreen())
                        );
                      },
                      title: 'Sign Up',
                      showIcon: false,
                      iconPath: ''),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
              Row(
                    mainAxisAlignment: MainAxisAlignment.center,      
                    children: [
                      const Text('Already have an account?',
                      style: AppTextStyle.bodyLargeMedium,),
                      SizedBox(
                    width: screenWidth*0.01,
                  ),
                      NormalTertiaryButton(
                        ontap: (){
                          Navigator.push(
                            context, MaterialPageRoute(
                              builder: (context)=>LoginPage()));
                        }, title: 'Login', 
                        showIcon: false,
                         iconPath: '')
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

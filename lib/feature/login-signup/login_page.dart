import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/divider.dart';
import 'package:silver_genie/core/widgets/form_components.dart';
import 'package:silver_genie/feature/login-signup/login_page_email.dart';
import 'package:silver_genie/feature/login-signup/otp_screen.dart';
import 'package:silver_genie/feature/login-signup/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String routeName = 'login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                      'Login',
                      style: AppTextStyle.heading4SemiBold,
                    ),
                    SizedBox(height: screenHeight * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    PhoneLableForm(
                      title: 'Enter Mobile Number', text: 'Mobile Number'),
                    SizedBox(height: screenHeight * 0.02),
                    LargeTertiaryButton(
                      ontap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=>const LoginPageEmail())
                          );
                      }, title: 'Use email instead',
                       showIcon: false, iconPath: ''),
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
                        title: 'Login',
                        showIcon: false,
                        iconPath: ''),
                    ),
                  SizedBox(height: screenHeight * 0.03),
                  const DividerComponent(),
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
              Row(
                    mainAxisAlignment: MainAxisAlignment.center,      
                    children: [
                      const Text("Don't have an account?",
                      style: AppTextStyle.bodyLargeMedium,),
                      SizedBox(
                      width: screenWidth*0.01,
                    ),
                        NormalTertiaryButton(
                          ontap: (){
                            Navigator.push(
                              context, MaterialPageRoute(
                                builder: (context)=>SignUpScreen()));
                          }, title: 'Sign Up', 
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


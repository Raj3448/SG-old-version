import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/form_components.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                      'Login',
                      style: AppTextStyle.heading4SemiBold,
                    ),
                    const SizedBox(height: Dimension.d6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextLabel(title: 'Mobile Number',),
                   const SizedBox(height: Dimension.d2),
                    const PhoneLableForm(
                      title: 'Enter Mobile Number',),
                    const SizedBox(height: Dimension.d4),
                    LargeTertiaryButton(
                      ontap: (){
                         GoRouter.of(context).go('/loginEmail');
                      }, title: 'Use email instead',
                       showIcon: false, iconPath: ''),
                      const SizedBox(height: Dimension.d4),
                  SizedBox(
                      width:double.infinity,
                      child: NormalPrimaryButton(
                        ontap: (){
                          GoRouter.of(context).go('/otp_screen');
                        },
                        title: 'Login',
                        showIcon: false,
                        iconPath: ''),
                    ),
                  const SizedBox(height: Dimension.d6),
                ],
              ),
              Row(
                    mainAxisAlignment: MainAxisAlignment.center,      
                    children: [
                      const Text("Don't have an account?",
                      style: AppTextStyle.bodyLargeMedium,),
                      SizedBox(
                      width: 2,
                    ),
                        NormalTertiaryButton(
                          ontap: (){
                            GoRouter.of(context).go('/signup');
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


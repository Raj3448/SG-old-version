import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/form_components.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static String routeName  = "/signup";
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
                    'Sign Up',
                    style: AppTextStyle.heading4SemiBold,
                  ),
                  const SizedBox(height: Dimension.d6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextLabel(title: 'Enter Full Name'),
                    const SizedBox(height:Dimension.d2),
                  CustomTextField(
                    hintText: 'Enter Name',
                    keyboardType: TextInputType.name),
                  const SizedBox(height: Dimension.d4),
                  const TextLabel(title: 'Enter Email'),
                    const SizedBox(height:Dimension.d2),
                  CustomTextField(
                    hintText: 'Enter E-mail',
                    keyboardType: TextInputType.emailAddress),
                  const SizedBox(height:Dimension.d4),
                  const TextLabel(title: 'Mobile Number'),
                    const SizedBox(height:Dimension.d2),
                  const CustomPhoneField(
                    title: 'Enter Mobile Number',),
                  const SizedBox(height: Dimension.d4),
                  SizedBox(
                    width:double.infinity,
                    child: CustomButton(
                      size: ButtonSize.normal,
                      type: ButtonType.primary,
                      expanded: true,
                      ontap: (){
                        GoRouter.of(context).go('/otp_screen');
                      },
                      title: 'Sign Up',
                      showIcon: false,
                      iconPath: Icons.not_interested,
                  ),
                  ),
                  const SizedBox(height: Dimension.d6),
                ],
              ),
              Row(
                    mainAxisAlignment: MainAxisAlignment.center,      
                    children: [
                      const Text('Already have an account?',
                      style: AppTextStyle.bodyLargeMedium,),
                      SizedBox(
                    width:Dimension.d1,
                  ),
                      CustomButton(
                          size: ButtonSize.normal,
                          type: ButtonType.tertiary,
                          expanded: true,
                          ontap: (){
                          GoRouter.of(context).go('/login');
                        }, title: 'Login', 
                        showIcon: false,
                         iconPath: Icons.not_interested,)
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

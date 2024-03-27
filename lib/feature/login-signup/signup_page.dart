import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/form_components.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
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
              Text(
                'Sign Up'.tr(),
                style: AppTextStyle.heading4SemiBold,
              ),
              const SizedBox(height: Dimension.d6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextLabel(title: 'Enter Full Name'.tr()),
                  const SizedBox(height: Dimension.d2),
                  CustomTextField(
                    hintText: 'Enter Name'.tr(),
                    keyboardType: TextInputType.name,
                    large: false,
                  ),
                  const SizedBox(height: Dimension.d4),
                  TextLabel(title: 'Enter Email'.tr()),
                  const SizedBox(height: Dimension.d2),
                  CustomTextField(
                    hintText: 'Enter E-mail'.tr(),
                    keyboardType: TextInputType.emailAddress,
                    large: false,
                  ),
                  const SizedBox(height: Dimension.d4),
                  TextLabel(title: 'Mobile Number'.tr()),
                  const SizedBox(height: Dimension.d2),
                  CustomPhoneField(
                    title: 'Enter Mobile Number'.tr(),
                  ),
                  const SizedBox(height: Dimension.d4),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      size: ButtonSize.normal,
                      type: ButtonType.primary,
                      expanded: true,
                      ontap: () {
                        GoRouter.of(context).push(RoutesConstants.otpRoute);
                      },
                      title: 'Sign Up'.tr(),
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
                      GoRouter.of(context).go(RoutesConstants.loginRoute);
                    },
                    title: 'Login'.tr(),
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

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/form_components.dart';
import 'package:silver_genie/feature/login-signup/store/login_store.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<LoginStore>();
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
                'Login'.tr(),
                style: AppTextStyle.heading4SemiBold,
              ),
              const SizedBox(height: Dimension.d6),
              Observer(
                builder: (context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextLabel(
                        title: store.isEmail
                            ? 'Enter email'
                            : 'Mobile Number'.tr(),
                      ),
                      const SizedBox(height: Dimension.d2),
                      if (store.isEmail)
                        const CustomTextField(
                          hintText: 'Enter e-mail',
                          keyboardType: TextInputType.emailAddress,
                          large: false,
                        )
                      else
                        CustomPhoneField(
                          title: 'Enter Mobile Number'.tr(),
                        ),
                      const SizedBox(height: Dimension.d4),
                      CustomButton(
                        size: ButtonSize.large,
                        type: ButtonType.tertiary,
                        expanded: false,
                        ontap: () {
                          store.isEmail = !store.isEmail;
                        },
                        title: store.isEmail
                            ? 'Use Mobile Number instead'.tr()
                            : 'Use email instead'.tr(),
                        showIcon: false,
                        iconPath: Icons.not_interested,
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
                          title: 'Login'.tr(),
                          showIcon: false,
                          iconPath: Icons.not_interested,
                        ),
                      ),
                      const SizedBox(height: Dimension.d6),
                    ],
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?".tr(),
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
                      GoRouter.of(context).push(RoutesConstants.signUpRoute);
                    },
                    title: 'Sign Up'.tr(),
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

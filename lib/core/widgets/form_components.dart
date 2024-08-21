// ignore_for_file: public_member_api_docs, sort_constructors_first, deprecated_member_use, lines_longer_than_80_chars, unnecessary_statements
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/utils/country_list.dart';
import 'package:silver_genie/core/utils/custom_country_picker/custom_country_picker.dart';
import 'package:silver_genie/feature/login-signup/store/login_store.dart';
import 'package:silver_genie/feature/login-signup/store/signup_store.dart';

class TextLabel extends StatelessWidget {
  const TextLabel({required this.title, super.key});

  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title.tr(),
      style:
          AppTextStyle.bodyMediumMedium.copyWith(color: AppColors.grayscale700),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.hintText,
    required this.keyboardType,
    required this.large,
    required this.enabled,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.onSaved,
    this.controller,
    this.validationLogic,
    this.textInputAction,
    this.initialValue,
    this.onChanged,
    super.key,
  });

  final String hintText;
  final TextInputType keyboardType;
  final bool large;
  final bool enabled;
  final TextEditingController? controller;
  final String? Function(String?)? validationLogic;
  final TextInputAction? textInputAction;

  final AutovalidateMode autovalidateMode;
  final String? initialValue;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      controller: controller,
      autovalidateMode: autovalidateMode,
      enabled: enabled,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: AppTextStyle.bodyLargeMedium.copyWith(
        color: !enabled ? AppColors.grayscale700 : AppColors.grayscale900,
      ),
      onSaved: onSaved,
      maxLines: 8,
      onChanged: onChanged,
      minLines: large ? 5 : 1,
      decoration: InputDecoration(
        hintText: hintText.tr(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintMaxLines: 5,
        hintStyle: AppTextStyle.bodyLargeMedium
            .copyWith(color: AppColors.grayscale600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimension.d2),
          borderSide: const BorderSide(
            color: AppColors.line,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimension.d2),
          borderSide: const BorderSide(
            color: AppColors.line,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimension.d2),
          borderSide: const BorderSide(
            color: AppColors.line,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimension.d2),
          borderSide: const BorderSide(
            color: AppColors.formValidationError,
          ),
        ),
        filled: !enabled ? true : null,
        fillColor: !enabled ? AppColors.grayscale200 : null,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimension.d2),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
      ),
      validator: validationLogic,
    );
  }
}

class CustomPhoneField extends StatelessWidget {
  const CustomPhoneField({
    required this.title,
    required this.autovalidate,
    this.controller,
    this.isSignUpComponent = false,
    super.key,
  });

  final String title;
  final TextEditingController? controller;
  final AutovalidateMode autovalidate;
  final bool isSignUpComponent;

  @override
  Widget build(BuildContext context) {
    final loginStore = GetIt.I<LoginStore>();
    final signUpStore = GetIt.I<SignupStore>();
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      autovalidateMode: autovalidate,
      decoration: InputDecoration(
        hintText: 'Enter mobile number',
        hintStyle: AppTextStyle.bodyLargeMedium.copyWith(height: 1.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimension.d2),
          borderSide: const BorderSide(
            color: AppColors.grayscale200,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimension.d2),
          borderSide: const BorderSide(
            color: AppColors.line,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimension.d2),
          borderSide: const BorderSide(
            color: AppColors.primary,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimension.d2),
          borderSide: const BorderSide(
            color: AppColors.formValidationError,
          ),
        ),
        prefixIcon: SizedBox(child: Observer(
          builder: (context) {
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => CustomCountryPickerDialog(
                    favorites: [
                      CountryApi.getCountryByIsoCode('IN'),
                    ],
                    onCountrySelection: (Country country) {
                      if (isSignUpComponent) {
                        signUpStore
                          ..selectCountryDialCode = country.phoneCode
                          ..selectCountryCode = country.isoCode
                          ..selectCountryFlagEmoji = country.flagEmoji;
                      } else {
                        loginStore
                          ..selectCountryDialCode = country.phoneCode
                          ..selectCountryCode = country.isoCode
                          ..selectCountryFlagEmoji = country.flagEmoji;
                      }
                    },
                  ),
                );
              },
              child: CountryCodeButtonComponent(
                isSignUpComponent: isSignUpComponent,
              ),
            );
          },
        )),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your phone number';
        }
        final countryCode = isSignUpComponent
            ? signUpStore.selectCountryCode ?? 'IN'
            : loginStore.selectCountryCode ?? 'IN';
        final requiredLength = countryMobileDigitCount[countryCode];
        if (requiredLength == null) {
          return 'Invalid country code';
        } else if (value.length != requiredLength) {
          return 'Please enter a valid phone number with $requiredLength digits';
        }
        return null;
      },
    );
  }
}

class CountryCodeButtonComponent extends StatelessWidget {
  final bool isSignUpComponent;
  CountryCodeButtonComponent({
    required this.isSignUpComponent,
    Key? key,
  }) : super(key: key);

  final signUpStore = GetIt.I<SignupStore>();
  final loginStore = GetIt.I<LoginStore>();

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimension.d2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isSignUpComponent
                    ? (signUpStore.selectCountryFlagEmoji ?? '🇮🇳')
                    : (loginStore.selectCountryFlagEmoji ?? '🇮🇳'),
                style: AppTextStyle.bodyXLMedium,
              ),
              const SizedBox(width: Dimension.d2),
              Text(
                  isSignUpComponent
                      ? (signUpStore.selectCountryDialCode ?? '91')
                      : (loginStore.selectCountryDialCode ?? '91'),
                  style: AppTextStyle.bodyLargeMedium
                      .copyWith(color: AppColors.grayscale900)),
              const SizedBox(width: Dimension.d2),
              const Icon(
                AppIcons.arrow_down_ios,
                size: 5,
              ),
              const SizedBox(width: Dimension.d2),
            ],
          ),
        );
      },
    );
  }
}

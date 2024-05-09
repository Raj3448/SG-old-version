// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';

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
    Key? key,
    required this.hintText,
    required this.keyboardType,
    required this.large,
    required this.enabled,
    this.controller,
    this.validationLogic,
    required this.isFieldDisable,
  }) : super(key: key);

  final String hintText;
  final TextInputType keyboardType;
  final bool large;
  final bool enabled;
  final TextEditingController? controller;
  final String? Function(String?)? validationLogic;
  final bool isFieldDisable;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: enabled,
      keyboardType: keyboardType,
      style: AppTextStyle.bodyLargeMedium.copyWith(
          color:
              isFieldDisable ? AppColors.grayscale700 : AppColors.grayscale900),
      maxLines: 8,
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
            width: 2,
          ),
        ),
      ),
      validator: validationLogic,
    );
  }
}

class CustomPhoneField extends StatelessWidget {
  const CustomPhoneField({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
        prefixIcon: SizedBox(
          child: CountryCodePicker(
            padding: EdgeInsets.zero,
            showDropDownButton: true,
            initialSelection: 'IN',
            flagWidth: 25,
            favorite: const ['+91', 'IN'],
            textStyle: AppTextStyle.bodyLargeMedium
                .copyWith(color: AppColors.grayscale900),
          ),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your phone number';
        } else if (value.length > 10 || value.length < 10) {
          return 'Please enter 10 digits phone number';
        }
        return null;
      },
    );
  }
}

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
    required this.hintText,
    required this.keyboardType,
    required this.large,
    required this.enabled,
    this.controller,
    super.key,
  });

  final String hintText;
  final TextInputType keyboardType;
  final bool large;
  final bool enabled;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      style:
          AppTextStyle.bodyLargeMedium.copyWith(color: AppColors.grayscale900),
      maxLines: 8,
      minLines: large ? 5 : 1,
      decoration: InputDecoration(
        hintText: hintText.tr(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintMaxLines: 5,
        hintStyle: AppTextStyle.bodyLargeMedium,
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
    );
  }
}
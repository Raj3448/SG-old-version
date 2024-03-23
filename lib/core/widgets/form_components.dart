import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';

class TextLabel extends StatelessWidget {
  const TextLabel({required this.title, super.key});

  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyle.bodyMediumMedium,
    );
  }
}

class InitialLabelForm extends StatelessWidget {
  InitialLabelForm({
    required this.hintText,
    required this.keyboardType,
    super.key,
  });

  final String hintText;
  final TextInputType keyboardType;
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyle.bodyLargeMedium,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class PhoneLableForm extends StatelessWidget {
  const PhoneLableForm({required this.title, super.key});

  final String title;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter mobile number',
                  hintStyle: AppTextStyle.bodyLargeMedium.copyWith(height: 1.5),
                  border: OutlineInputBorder(),
                  // prefixIconConstraints: BoxConstraints(maxWidth: 140),
                  prefixIcon: SizedBox(
                    // width: 130,
                    child: CountryCodePicker(
                      // hideSearch: true,
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


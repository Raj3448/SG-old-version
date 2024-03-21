import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:silver_genie/core/constants/text_styles.dart';

class InitialLabelForm extends StatelessWidget {
  InitialLabelForm({
    required this.title,
    required this.hintText,
    required this.keyboardType,
    super.key,
  });

  final String title;
  final String hintText;
  final TextInputType keyboardType;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle.bodyMediumMedium,
        ),
        const SizedBox(
          height: 4,
        ),
        TextField(
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyle.bodyLargeMedium,
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

class PhoneLableForm extends StatelessWidget {
  const PhoneLableForm({
    required this.title,
    required this.text,
    super.key});
  
  final String title;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: AppTextStyle.bodyMediumMedium,
        ),
        const SizedBox(
          height: 4,
        ),
        IntlPhoneField(
          decoration: InputDecoration(
                          hintText: title,
                          hintStyle: AppTextStyle.bodyLargeMedium,
                          counterText: '',
                          border: OutlineInputBorder(),)
        ),
      ],
    );
  }
}

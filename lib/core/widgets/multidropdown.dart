// ignore_for_file: strict_raw_type

import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';

class MultiDropdown extends StatelessWidget {
  const MultiDropdown({
    required this.values,
    super.key,
  });

  final List<ValueItem> values;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.line),
      ),
      padding: const EdgeInsets.only(right: 10),
      child: MultiSelectDropDown(
        onOptionSelected: (selectedOptions) {},
        options: values,
        selectionType: SelectionType.single,
        optionTextStyle: AppTextStyle.bodyLargeMedium,
        hintStyle: AppTextStyle.bodyLargeMedium
            .copyWith(color: AppColors.grayscale700),
        singleSelectItemStyle: AppTextStyle.bodyLargeMedium
            .copyWith(color: AppColors.grayscale900),
        dropdownHeight: 160,
        borderRadius: 8,
        dropdownBorderRadius: 8,
        selectedOptionTextColor: AppColors.primary,
        selectedOptionIcon: const Icon(
          AppIcons.check,
          color: AppColors.primary,
          size: 15,
        ),
        clearIcon: const Icon(
          Icons.clear_outlined,
          color: AppColors.grayscale700,
          size: 20,
        ),
        suffixIcon: const Icon(
          AppIcons.arrow_down_ios,
          color: AppColors.grayscale700,
          size: 7,
        ),
        inputDecoration: const BoxDecoration(),
      ),
    );
  }
}

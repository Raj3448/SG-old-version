// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: strict_raw_type, library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';

class MultiSelectFormField extends FormField<List<ValueItem<dynamic>>> {
  MultiSelectFormField({
    required List<ValueItem> values,
    super.key,
    MultiSelectController? controller,
    bool searchEnabled = false,
    List<ValueItem<dynamic>>? selectedOptions,
    super.onSaved,
    super.validator,
    bool enabled = true,
    bool showClear = true,
  }) : super(
          initialValue: selectedOptions,
          builder: (FormFieldState<List<ValueItem<dynamic>>> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: !enabled ? AppColors.grayscale200 : null,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: state.hasError && !state.isValid
                            ? AppColors.error
                            : AppColors.line),
                  ),
                  padding: const EdgeInsets.only(right: 10),
                  child: IgnorePointer(
                    ignoring: !enabled,
                    child: MultiSelectDropDown(
                      searchEnabled: searchEnabled,
                      controller: controller,
                      onOptionSelected: (selectedOptions) {
                        state.didChange(selectedOptions);
                        if (onSaved != null) {
                          onSaved(selectedOptions);
                        }
                      },
                      selectedOptions: state.value ?? [],
                      options: values,
                      selectionType: SelectionType.single,
                      optionTextStyle: AppTextStyle.bodyLargeMedium,
                      hintStyle: AppTextStyle.bodyLargeMedium
                          .copyWith(color: AppColors.grayscale600),
                      singleSelectItemStyle: AppTextStyle.bodyLargeMedium
                          .copyWith(
                              color: !enabled
                                  ? AppColors.grayscale700
                                  : AppColors.grayscale900),
                      dropdownHeight:
                          values.length > 4 ? 160 : values.length * 50,
                      borderRadius: 8,
                      dropdownBorderRadius: 8,
                      selectedOptionTextColor: AppColors.primary,
                      selectedOptionIcon: const Icon(
                        AppIcons.check,
                        color: AppColors.primary,
                        size: 15,
                      ),
                      clearIcon: showClear
                          ? const Icon(
                              Icons.clear_outlined,
                              color: AppColors.grayscale700,
                              size: 20,
                            )
                          : null,
                      suffixIcon: const Icon(
                        AppIcons.arrow_down_ios,
                        color: AppColors.grayscale700,
                        size: 7,
                      ),
                      inputDecoration: const BoxDecoration(),
                    ),
                  ),
                ),
                if (state.errorText != null && !state.isValid)
                  Padding(
                    padding: const EdgeInsets.only(
                        top: Dimension.d2, left: Dimension.d4),
                    child: Text(
                      state.errorText!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
}

class RelationDropdown extends StatelessWidget {
  const RelationDropdown({
    super.key,
    this.controller,
    this.selectedOption,
  });

  final MultiSelectController? controller;
  final ValueItem<String>? selectedOption;
  @override
  Widget build(BuildContext context) {
    return MultiSelectFormField(
      selectedOptions: selectedOption == null ? [] : [selectedOption!],
      values: [
        ValueItem(label: 'Father'.tr(), value: 'Father'),
        ValueItem(label: 'Mother'.tr(), value: 'Mother'),
        ValueItem(label: 'Sister'.tr(), value: 'Sister'),
        ValueItem(label: 'Brother'.tr(), value: 'Brother'),
        ValueItem(label: 'Daughter'.tr(), value: 'Daughter'),
        ValueItem(label: 'Son'.tr(), value: 'Son'),
        ValueItem(label: 'Wife'.tr(), value: 'Wife'),
      ],
    );
  }
}

class DateDropdown extends FormField<DateTime> {
  DateDropdown({
    required TextEditingController controller,
    bool disable = false,
    super.key,
    String dateFormat = 'yyyy-MM-dd',
    void Function(String?)? onSaved,
    void Function(DateTime)? onChanged,
    super.validator,
  }) : super(
          initialValue: controller.text.isEmpty
              ? null
              : DateFormat(dateFormat).parse(controller.text),
          builder: (FormFieldState<DateTime> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: disable ? AppColors.grayscale200 : null,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: state.hasError && !state.isValid
                          ? AppColors.error
                          : AppColors.grayscale300,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller,
                              style: AppTextStyle.bodyLargeMedium.copyWith(
                                color: disable
                                    ? AppColors.grayscale700
                                    : AppColors.grayscale900,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Select',
                                border: InputBorder.none,
                              ),
                              readOnly: true,
                              onSaved: onSaved,
                              onTap: disable
                                  ? null
                                  : () async {
                                      final pickedDate = await showDatePicker(
                                        context: state.context,
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime.now(),
                                        initialDate:
                                            state.value ?? DateTime.now(),
                                      );

                                      if (pickedDate != null &&
                                          pickedDate != state.value) {
                                        state.didChange(pickedDate);
                                        controller.text = DateFormat(dateFormat)
                                            .format(pickedDate);
                                        onChanged?.call(pickedDate);
                                      }
                                    },
                              onChanged: (value) {
                                if (onChanged != null) {
                                  onChanged.call(state.value!);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.grey,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (state.errorText != null && !state.isValid)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: Dimension.d2,
                      left: Dimension.d4,
                    ),
                    child: Text(
                      state.errorText!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
}

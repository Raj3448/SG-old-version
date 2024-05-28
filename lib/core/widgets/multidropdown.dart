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
    Key? key,
    required List<ValueItem> values,
    MultiSelectController? controller,
    List<ValueItem<dynamic>>? selectedOptions,
    FormFieldSetter<List<ValueItem<dynamic>>>? onSaved,
    String? Function(List<ValueItem<dynamic>>?)? validator,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: selectedOptions,
          builder: (FormFieldState<List<ValueItem<dynamic>>> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.line),
                  ),
                  padding: const EdgeInsets.only(right: 10),
                  child: MultiSelectDropDown(
                    controller: controller,
                    onOptionSelected: (selectedOptions) {
                      state.didChange(selectedOptions);
                    },
                    selectedOptions: state.value ?? [],
                    options: values,
                    selectionType: SelectionType.single,
                    optionTextStyle: AppTextStyle.bodyLargeMedium,
                    hintStyle: AppTextStyle.bodyLargeMedium
                        .copyWith(color: AppColors.grayscale600),
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
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimension.d1),
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
    Key? key,
    this.controller,
    this.selectedOption,
  }) : super(key: key);

  final MultiSelectController? controller;
  final ValueItem<String>? selectedOption;
  @override
  Widget build(BuildContext context) {
    return MultiSelectFormField(
      selectedOptions: selectedOption == null? [] : [selectedOption!],
      values: [
        ValueItem(label: 'Father'.tr(), value: 'Father'),
        ValueItem(label: 'Mother'.tr(), value: 'Mother'),
        ValueItem(label: 'Sister'.tr(), value: 'Sister'),
        ValueItem(label: 'Brother'.tr(), value: 'Brother'),
        ValueItem(label: 'Daughter'.tr(), value: 'Daughter'),
        ValueItem(label: 'Son'.tr(), value: 'Son'),
        ValueItem(label: 'Wife'.tr(), value: 'Wife'),
        ValueItem(label: 'Self'.tr(), value: 'Self'),
      ],
    );
  }
}

class DateDropdown extends FormField<DateTime> {
  DateDropdown({
    Key? key,
    required TextEditingController controller,
    FormFieldSetter<DateTime>? onSaved,
    FormFieldValidator<DateTime>? validator,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: controller.text.isEmpty
              ? null
              : DateFormat('yyyy-MM-dd').parse(controller.text),
          builder: (FormFieldState<DateTime> state) {
            return GestureDetector(
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: state.context,
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                  initialDate: state.value ?? DateTime.now(),
                );

                if (pickedDate != null && pickedDate != state.value) {
                  state.didChange(pickedDate);
                  controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.grayscale300),
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
                            style: AppTextStyle.bodyLargeMedium
                                .copyWith(color: AppColors.grayscale900),
                            decoration: const InputDecoration(
                              hintText: 'Select',
                              border: InputBorder.none,
                            ),
                            readOnly: true,
                            onTap: () async {
                              final pickedDate = await showDatePicker(
                                context: state.context,
                                firstDate: DateTime(1950),
                                lastDate: DateTime.now(),
                                initialDate: state.value ?? DateTime.now(),
                              );

                              if (pickedDate != null &&
                                  pickedDate != state.value) {
                                state.didChange(pickedDate);
                                controller.text =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
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
                    if (state.hasError)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                          state.errorText!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
}

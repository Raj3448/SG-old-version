// ignore_for_file: strict_raw_type, library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';

class MultiDropdown extends StatefulWidget {
  const MultiDropdown({
    required this.values,
    this.controller,
    super.key,
  });

  final List<ValueItem> values;
  final MultiSelectController? controller;

  @override
  State<MultiDropdown> createState() => _MultiDropdownState();
}

class _MultiDropdownState extends State<MultiDropdown> {
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
        controller: widget.controller,
        onOptionSelected: (selectedOptions) {},
        options: widget.values,
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
    );
  }
}

class RelationDropdown extends StatelessWidget {
  const RelationDropdown({super.key, this.controller});

  final MultiSelectController? controller;

  @override
  Widget build(BuildContext context) {
    return MultiDropdown(
      controller: controller,
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

class GenderDropdown extends StatelessWidget {
  const GenderDropdown({super.key, this.controller});

  final MultiSelectController? controller;

  @override
  Widget build(BuildContext context) {
    return MultiDropdown(
      controller: controller,
      values: [
        ValueItem(label: 'Male'.tr(), value: 'Male'),
        ValueItem(label: 'Female'.tr(), value: 'Female'),
        ValueItem(label: 'Other'.tr(), value: 'Other'),
      ],
    );
  }
}

class DateDropdown extends StatefulWidget {
  const DateDropdown({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  _DateDropdownState createState() => _DateDropdownState();
}

class _DateDropdownState extends State<DateDropdown> {
  late TextEditingController _dateController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _dateController = widget.controller;
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
          initialDate: _selectedDate ?? DateTime.now(),
        );

        if (pickedDate != null && pickedDate != _selectedDate) {
          setState(() {
            _selectedDate = pickedDate;
            _dateController.text =
                DateFormat('yyyy-MM-dd').format(_selectedDate!);
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.line),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  hintText: 'Select',
                  border: InputBorder.none,
                ),
                readOnly: true,
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                    initialDate: _selectedDate ?? DateTime.now(),
                  );

                  if (pickedDate != null && pickedDate != _selectedDate) {
                    setState(() {
                      _selectedDate = pickedDate;
                      _dateController.text =
                          DateFormat('yyyy-MM-dd').format(_selectedDate!);
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              AppIcons.calendar,
              color: AppColors.grayscale700,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

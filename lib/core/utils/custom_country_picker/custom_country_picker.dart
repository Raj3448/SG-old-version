// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/utils/country_list.dart';

class CustomCountryPickerDialog extends StatefulWidget {
  final List<Country>? favorites;
  final void Function(Country)? onCountrySelection;

  const CustomCountryPickerDialog({
    this.onCountrySelection,
    this.favorites,
    Key? key,
  }) : super(key: key);

  @override
  _CustomCountryPickerDialogState createState() =>
      _CustomCountryPickerDialogState();
}

class _CustomCountryPickerDialogState extends State<CustomCountryPickerDialog> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;

    final filteredCountries = countries.where((country) {
      final query = _searchQuery.toLowerCase();
      return country.name.toLowerCase().contains(query) ||
          country.isoCode.toLowerCase().contains(query) ||
          country.phoneCode.contains(query);
    }).toList();

    final combinedList = [
      if (_searchQuery.isNotEmpty)
        ...<Country>[]
      else
        ...widget.favorites ?? [],
      ...filteredCountries
    ];

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: Dimension.d5),
      child: Container(
        height: mediaSize.height * 0.6,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(Dimension.d2),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimension.d4,
          vertical: Dimension.d6,
        ),
        child: Column(
          children: [
            TextField(
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search...',
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
                prefixIcon: Image.asset('assets/icon/Icon - Search.png'),
              ),
            ),
            const SizedBox(
              height: Dimension.d4,
            ),
            if (filteredCountries.isEmpty)
              const Text(
                'Country not found',
                style: AppTextStyle.bodyLargeMedium,
              )
            else
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (widget.onCountrySelection != null) {
                          widget.onCountrySelection!(combinedList[index]);
                        }
                        context.pop();
                      },
                      child: CountryListTileView(
                        country: combinedList[index],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    color:
                        widget.favorites != null && widget.favorites!.isNotEmpty
                            ? widget.favorites!.length - 1 == index &&
                                    _searchQuery.isEmpty
                                ? AppColors.grayscale500
                                : AppColors.grayscale200
                            : AppColors.grayscale200,
                  ),
                  itemCount: combinedList.length,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CountryListTileView extends StatelessWidget {
  final Country country;

  const CountryListTileView({
    required this.country,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimension.d1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            country.flagEmoji,
            style: AppTextStyle.bodyXLSemiBold.copyWith(fontSize: 22),
          ),
          const SizedBox(
            width: Dimension.d3,
          ),
          Expanded(
            child: Text(
              country.name,
              style: AppTextStyle.bodyLargeMedium,
            ),
          ),
          Expanded(
            child: Text(
              '(${country.phoneCode})',
              style: AppTextStyle.bodyLargeMedium,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/fonts.dart';
import 'package:silver_genie/core/constants/text_styles.dart';

class SearchTextfieldComponet extends StatefulWidget {
  const SearchTextfieldComponet({Key? key}) : super(key: key);

  @override
  State<SearchTextfieldComponet> createState() =>
      _SearchTextfieldComponetState();
}

class _SearchTextfieldComponetState extends State<SearchTextfieldComponet> {
  final FocusNode _searchFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: TextFormField(
        focusNode: _searchFocusNode,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
            prefixIcon: Image.asset(
              'assets/icon/Icon - Search.png',
              width: 18,
              height: 18,
              fit: BoxFit.scaleDown,
            ),
            prefixIconColor: Colors.black,
            fillColor: Colors.white24,
            filled: true,
            border: InputBorder.none,
            hintText: 'Search...',
            hintStyle: AppTextStyle.bodyMediumMedium.copyWith(
                color: AppColors.grayscale600,
                fontSize: 16,
                height: 1.46,
                fontWeight: FontWeight.w400,
                fontFamily: FontFamily.inter),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 2, color: AppColors.secondary),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 2, color: AppColors.primary),
                borderRadius: BorderRadius.circular(10))),
        onFieldSubmitted: (value) {
          _searchFocusNode.unfocus();
        },
      ),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/buttons.dart';

class BackToHomeComponent extends StatelessWidget {
  final String title;
  
  final String description;

  const BackToHomeComponent({
    
    required this.title,
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icon/success.svg',
                  height: 92,
                ),
                const SizedBox(
                  height: Dimension.d4,
                ),
                Text(
                  title,
                  style: AppTextStyle.bodyLargeMedium.copyWith(
                      color: AppColors.grayscale900,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: Dimension.d2,
                ),
                Text(
                  description,
                  style: AppTextStyle.bodyMediumMedium.copyWith(
                    color: AppColors.grayscale700,
                  ),
                ),
                const SizedBox(
                  height: Dimension.d6,
                ),
                CustomButton(
                  ontap: () {
                    Navigator.of(context).pop();
                  },
                  iconColor: AppColors.black,
                  title: 'Back to Home',
                  showIcon: false,
                  iconPath: AppIcons.add,
                  size: ButtonSize.normal,
                  type: ButtonType.primary,
                  expanded: true,
                ),
              ],
            );
  }
}

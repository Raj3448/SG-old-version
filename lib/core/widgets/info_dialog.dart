import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/widgets/buttons.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({
    required this.showIcon,
    required this.title,
    required this.desc,
    required this.btnTitle,
    required this.showBtnIcon,
    required this.btnIconPath,
    super.key,
  });

  final bool showIcon;
  final String title;
  final String desc;
  final String btnTitle;
  final bool showBtnIcon;
  final IconData btnIconPath;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimension.d4,
          vertical: Dimension.d6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon)
              Column(
                children: [
                  SvgPicture.asset(
                    'assets/icon/success.svg',
                    height: 88,
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? 10
                          : 30),
                ],
              )
            else
              const SizedBox(),
            Text(
              title.tr(),
              style: AppTextStyle.bodyXLBold.copyWith(height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              desc.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyLargeMedium,
            ),
            SizedBox(
                height:
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? 10
                        : 20),
            CustomButton(
              ontap: () {
                GoRouter.of(context).pop();
              },
              title: btnTitle.tr(),
              showIcon: showBtnIcon,
              iconPath: btnIconPath,
              size: ButtonSize.normal,
              type: ButtonType.primary,
              expanded: false,
              iconColor: AppColors.lightRed,
            ),
          ],
        ),
      ),
    );
  }
}

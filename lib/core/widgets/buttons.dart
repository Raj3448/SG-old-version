// ignore_for_file: no_default_cases

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';

enum ButtonSize {
  small,
  normal,
  large,
}

enum ButtonType {
  primary,
  secondary,
  tertiary,
  disable,
  state,
  activation,
  warnActivate
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.ontap,
    required this.title,
    required this.showIcon,
    required this.iconPath,
    required this.size,
    required this.type,
    required this.expanded,
    super.key,
  });
  final VoidCallback ontap;
  final String title;
  final bool showIcon;
  final IconData iconPath;
  final ButtonSize size;
  final ButtonType type;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    if (type == ButtonType.tertiary) {
      return GestureDetector(
        onTap: ontap,
        child: Text(
          title.tr(),
          style: _getTextStyle(),
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: ontap,
        style: ElevatedButton.styleFrom(
          surfaceTintColor: Colors.transparent,
          minimumSize: _getButtonSize(),
          backgroundColor: _getBackgroundColor(),
          shape: RoundedRectangleBorder(
            borderRadius: size == ButtonSize.small
                ? BorderRadius.circular(4)
                : BorderRadius.circular(8),
            side: _getButtonBorder(),
          ),
        ),
        child: showIcon
            ? expanded
                ? Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(iconPath, color: AppColors.white),
                        const SizedBox(width: 5),
                        Text(
                          title.tr(),
                          style: _getTextStyle(),
                        ),
                      ],
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        iconPath,
                        color: Colors.white,
                        size: 17,
                      ),
                      const SizedBox(width: 7.5),
                      Text(
                        title.tr(),
                        style: _getTextStyle(),
                      ),
                    ],
                  )
            : expanded
                ? Center(
                    child: Text(
                      title.tr(),
                      style: _getTextStyle(),
                    ),
                  )
                : Text(
                    title.tr(),
                    style: _getTextStyle(),
                  ),
      );
    }
  }

  Size _getButtonSize() {
    switch (size) {
      case ButtonSize.small:
        return const Size(133, 28);
      case ButtonSize.normal:
        return const Size(164, 48);
      case ButtonSize.large:
        return const Size(178, 56);
    }
  }

  Color _getBackgroundColor() {
    switch (type) {
      case ButtonType.primary:
        return AppColors.primary;
      case ButtonType.secondary:
        return AppColors.white;
      case ButtonType.tertiary:
        return AppColors.white;
      case ButtonType.disable:
        return AppColors.grayscale200;
      case ButtonType.state:
        return AppColors.success;
      case ButtonType.activation:
        return AppColors.error;
      case ButtonType.warnActivate:
        return AppColors.warning2;
    }
  }

  BorderSide _getButtonBorder() {
    switch (type) {
      case ButtonType.secondary:
        return const BorderSide(color: AppColors.primary);
      default:
        return BorderSide.none;
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return AppTextStyle.bodyMediumMedium.copyWith(
          color: _getTextColor(),
        );
      case ButtonSize.normal:
        return AppTextStyle.bodyLargeMedium.copyWith(
          color: _getTextColor(),
        );
      case ButtonSize.large:
        return AppTextStyle.bodyLargeMedium.copyWith(
          color: _getTextColor(),
        );
    }
  }

  Color _getTextColor() {
    switch (type) {
      case ButtonType.primary:
        return AppColors.white;
      case ButtonType.secondary:
        return AppColors.primary;
      case ButtonType.tertiary:
        return AppColors.primary;
      case ButtonType.disable:
        return AppColors.grayscale600;
      case ButtonType.state:
        return AppColors.grayscale100;
      case ButtonType.activation:
        return AppColors.secondary;
      case ButtonType.warnActivate:
        return AppColors.secondary;
    }
  }
}

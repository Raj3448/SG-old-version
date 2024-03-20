import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';

class SmallPrimaryButton extends StatelessWidget {
  const SmallPrimaryButton({
    required this.ontap,
    required this.title,
    required this.showIcon,
    required this.iconPath,
    super.key,
  });

  final VoidCallback ontap;
  final String title;
  final bool showIcon;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(133, 28),
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: showIcon
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: Colors.black),
                // SvgPicture.asset(iconPath),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: AppTextStyle.bodyMediumMedium
                      .copyWith(color: AppColors.white),
                ),
              ],
            )
          : Text(
              title,
              style: AppTextStyle.bodyMediumMedium
                  .copyWith(color: AppColors.white),
            ),
    );
  }
}

class NormalPrimaryButton extends StatelessWidget {
  const NormalPrimaryButton({
    required this.ontap,
    required this.title,
    required this.showIcon,
    required this.iconPath,
    super.key,
  });

  final VoidCallback ontap;
  final String title;
  final bool showIcon;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(164, 48),
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: showIcon
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: Colors.black),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: AppTextStyle.bodyLargeMedium
                      .copyWith(color: AppColors.white),
                ),
              ],
            )
          : Text(
              title,
              style:
                  AppTextStyle.bodyLargeMedium.copyWith(color: AppColors.white),
            ),
    );
  }
}

class LargePrimaryButton extends StatelessWidget {
  const LargePrimaryButton({
    required this.ontap,
    required this.title,
    required this.showIcon,
    required this.iconPath,
    super.key,
  });

  final VoidCallback ontap;
  final String title;
  final bool showIcon;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(178, 56),
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: showIcon
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: Colors.black),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: AppTextStyle.bodyLargeMedium
                      .copyWith(color: AppColors.white),
                ),
              ],
            )
          : Text(
              title,
              style:
                  AppTextStyle.bodyLargeMedium.copyWith(color: AppColors.white),
            ),
    );
  }
}

class SmallSecondaryButton extends StatelessWidget {
  const SmallSecondaryButton({
    required this.ontap,
    required this.title,
    required this.showIcon,
    required this.iconPath,
    super.key,
  });

  final VoidCallback ontap;
  final String title;
  final bool showIcon;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(156, 30),
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.primary),
        ),
      ),
      child: showIcon
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: Colors.black),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: AppTextStyle.bodyMediumMedium
                      .copyWith(color: AppColors.primary),
                ),
              ],
            )
          : Text(
              title,
              style: AppTextStyle.bodyMediumMedium
                  .copyWith(color: AppColors.white),
            ),
    );
  }
}

class NormalSecondaryButton extends StatelessWidget {
  const NormalSecondaryButton({
    required this.ontap,
    required this.title,
    required this.showIcon,
    required this.iconPath,
    super.key,
  });

  final VoidCallback ontap;
  final String title;
  final bool showIcon;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(187, 48),
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.primary),
        ),
      ),
      child: showIcon
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: Colors.black),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: AppTextStyle.bodyLargeMedium
                      .copyWith(color: AppColors.primary),
                ),
              ],
            )
          : Text(
              title,
              style:
                  AppTextStyle.bodyLargeMedium.copyWith(color: AppColors.white),
            ),
    );
  }
}

class LargeSecondaryButton extends StatelessWidget {
  const LargeSecondaryButton({
    required this.ontap,
    required this.title,
    required this.showIcon,
    required this.iconPath,
    super.key,
  });

  final VoidCallback ontap;
  final String title;
  final bool showIcon;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(204, 58),
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.primary),
        ),
      ),
      child: showIcon
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: Colors.black),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: AppTextStyle.bodyLargeMedium
                      .copyWith(color: AppColors.primary),
                ),
              ],
            )
          : Text(
              title,
              style:
                  AppTextStyle.bodyLargeMedium.copyWith(color: AppColors.white),
            ),
    );
  }
}

class SmallTertiaryButton extends StatelessWidget {
  const SmallTertiaryButton({
    required this.ontap,
    required this.title,
    required this.showIcon,
    required this.iconPath,
    super.key,
  });

  final VoidCallback ontap;
  final String title;
  final bool showIcon;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: showIcon
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: Colors.black),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: AppTextStyle.bodyMediumMedium
                      .copyWith(color: AppColors.primary),
                ),
              ],
            )
          : Text(
              title,
              style: AppTextStyle.bodyMediumMedium
                  .copyWith(color: AppColors.white),
            ),
    );
  }
}

class NormalTertiaryButton extends StatelessWidget {
  const NormalTertiaryButton({
    required this.ontap,
    required this.title,
    required this.showIcon,
    required this.iconPath,
    super.key,
  });

  final VoidCallback ontap;
  final String title;
  final bool showIcon;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: showIcon
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: Colors.black),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: AppTextStyle.bodyLargeMedium
                      .copyWith(color: AppColors.primary),
                ),
              ],
            )
          : Text(
              title,
              style:
                  AppTextStyle.bodyLargeMedium.copyWith(color: AppColors.white),
            ),
    );
  }
}

class LargeTertiaryButton extends StatelessWidget {
  const LargeTertiaryButton({
    required this.ontap,
    required this.title,
    required this.showIcon,
    required this.iconPath,
    super.key,
  });

  final VoidCallback ontap;
  final String title;
  final bool showIcon;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: showIcon
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: Colors.black),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: AppTextStyle.bodyLargeMedium
                      .copyWith(color: AppColors.primary),
                ),
              ],
            )
          : Text(
              title,
              style:
                  AppTextStyle.bodyLargeMedium.copyWith(color: AppColors.white),
            ),
    );
  }
}

class SmallDisableButton extends StatelessWidget {
  const SmallDisableButton({
    required this.ontap,
    required this.title,
    required this.showIcon,
    required this.iconPath,
    super.key,
  });

  final VoidCallback ontap;
  final String title;
  final bool showIcon;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(131, 28),
        backgroundColor: AppColors.grayscale200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: showIcon
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: Colors.black),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: AppTextStyle.bodyMediumMedium
                      .copyWith(color: AppColors.grayscale600),
                ),
              ],
            )
          : Text(
              title,
              style: AppTextStyle.bodyMediumMedium
                  .copyWith(color: AppColors.grayscale600),
            ),
    );
  }
}

class NormalDisableButton extends StatelessWidget {
  const NormalDisableButton({
    required this.ontap,
    required this.title,
    required this.showIcon,
    required this.iconPath,
    super.key,
  });

  final VoidCallback ontap;
  final String title;
  final bool showIcon;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(161, 48),
        backgroundColor: AppColors.grayscale200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: showIcon
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: Colors.black),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: AppTextStyle.bodyLargeMedium
                      .copyWith(color: AppColors.grayscale600),
                ),
              ],
            )
          : Text(
              title,
              style: AppTextStyle.bodyLargeMedium
                  .copyWith(color: AppColors.grayscale600),
            ),
    );
  }
}

class LargeDisableButton extends StatelessWidget {
  const LargeDisableButton({
    required this.ontap,
    required this.title,
    required this.showIcon,
    required this.iconPath,
    super.key,
  });

  final VoidCallback ontap;
  final String title;
  final bool showIcon;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(177, 56),
        backgroundColor: AppColors.grayscale200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: showIcon
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: Colors.black),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: AppTextStyle.bodyLargeMedium
                      .copyWith(color: AppColors.grayscale600),
                ),
              ],
            )
          : Text(
              title,
              style: AppTextStyle.bodyLargeMedium
                  .copyWith(color: AppColors.grayscale600),
            ),
    );
  }
}

class SmallStateButton extends StatelessWidget {
  const SmallStateButton({
    required this.ontap,
    required this.title,
    required this.showIcon,
    required this.iconPath,
    super.key,
  });

  final VoidCallback ontap;
  final String title;
  final bool showIcon;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(117, 28),
        backgroundColor: AppColors.success,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: showIcon
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: Colors.black),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: AppTextStyle.bodyMediumMedium
                      .copyWith(color: AppColors.grayscale100),
                ),
              ],
            )
          : Text(
              title,
              style: AppTextStyle.bodyMediumMedium
                  .copyWith(color: AppColors.grayscale100),
            ),
    );
  }
}

class NormalStateButton extends StatelessWidget {
  const NormalStateButton({
    required this.ontap,
    required this.title,
    required this.showIcon,
    required this.iconPath,
    super.key,
  });

  final VoidCallback ontap;
  final String title;
  final bool showIcon;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(145, 48),
        backgroundColor: AppColors.success,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: showIcon
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: Colors.black),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: AppTextStyle.bodyLargeMedium
                      .copyWith(color: AppColors.grayscale100),
                ),
              ],
            )
          : Text(
              title,
              style: AppTextStyle.bodyLargeMedium
                  .copyWith(color: AppColors.grayscale100),
            ),
    );
  }
}

class LargeStateButton extends StatelessWidget {
  const LargeStateButton({
    required this.ontap,
    required this.title,
    required this.showIcon,
    required this.iconPath,
    super.key,
  });

  final VoidCallback ontap;
  final String title;
  final bool showIcon;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(160, 56),
        backgroundColor: AppColors.success,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: showIcon
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: Colors.black),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: AppTextStyle.bodyLargeMedium
                      .copyWith(color: AppColors.grayscale100),
                ),
              ],
            )
          : Text(
              title,
              style: AppTextStyle.bodyLargeMedium
                  .copyWith(color: AppColors.grayscale100),
            ),
    );
  }
}

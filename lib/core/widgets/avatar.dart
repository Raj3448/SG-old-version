import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';

enum AvatarSize {
  size16,
  size18,
  size20,
  size22,
  size24,
  size32,
  size44,
  size48,
  size56,
}

class Avatar extends StatelessWidget {
  const Avatar({
    required this.imgPath,
    required this.maxRadius,
    super.key,
  });
  factory Avatar.fromSize({
    required String imgPath,
    required AvatarSize size,
  }) {
    double radius;
    switch (size) {
      case AvatarSize.size16:
        radius = 16;
      case AvatarSize.size18:
      radius = 18;
      case AvatarSize.size20:
        radius = 20;
      case AvatarSize.size22:
        radius = 22;
      case AvatarSize.size24:
        radius = 24;
      case AvatarSize.size32:
        radius = 32;
      case AvatarSize.size44:
        radius = 44;
      case AvatarSize.size48:
        radius = 48;
      case AvatarSize.size56:
        radius = 56;
    
    }
    return Avatar(imgPath: imgPath, maxRadius: radius);
  }
  final String imgPath;
  final double maxRadius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      maxRadius: maxRadius,
      backgroundImage: const AssetImage('assets/icon/headshot.png'),
      // backgroundImage: NetworkImage(imgPath),
    );
  }
}

class SelectableAvatar extends Avatar {
  final bool isSelected;
  final VoidCallback ontap;

  const SelectableAvatar({
    required String imgPath,
    required double maxRadius,
    required this.isSelected,
    required this.ontap,
    Key? key,
  }) : super(imgPath: imgPath, maxRadius: maxRadius, key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.7),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: CircleAvatar(
          maxRadius: maxRadius,
          backgroundImage: const AssetImage('assets/icon/headshot.png'),
          // backgroundImage: NetworkImage(imgPath),
        ),
      ),
    );
  }
}

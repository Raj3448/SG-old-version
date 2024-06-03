// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';

enum AvatarSize {
  size12,
  size14,
  size16,
  size18,
  size20,
  size22,
  size24,
  size32,
  size44,
  size48,
  size56,
  size58,
  size60
}

class Avatar extends StatelessWidget {
  const Avatar({
    required this.imgPath,
    required this.maxRadius,
    this.isNetworkImage = false,
    this.isImageSquare = false,
    this.fit = BoxFit.cover,
    Key? key,
  }) : super(key: key);
  factory Avatar.fromSize({
    bool isnetworkImage = false,
    bool isImageSquare = false,
    BoxFit fit = BoxFit.cover,
    required String imgPath,
    required AvatarSize size,
  }) {
    double radius;
    bool isNetworkImage = isnetworkImage;
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
      case AvatarSize.size14:
        radius = 14;
      case AvatarSize.size12:
        radius = 12;
      case AvatarSize.size58:
        radius = 58;
      case AvatarSize.size60:
        radius = 60;
    }
    return Avatar(
      imgPath: imgPath,
      maxRadius: radius,
      isNetworkImage: isNetworkImage,
      isImageSquare: isImageSquare,
      fit: fit,
    );
  }
  final String imgPath;
  final double maxRadius;
  final bool isNetworkImage;
  final bool isImageSquare;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: maxRadius * 2,
      width: maxRadius * 2,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: isImageSquare ? BoxShape.rectangle : BoxShape.circle,
        image: imgPath == ''
            ? DecorationImage(
                fit: fit,
                image: const AssetImage('assets/icon/default _profile.png'),
              )
            : null,
      ),
      child: imgPath == ''
          ? null
          : imgPath == 'assets/icon/44Px.png'
              ? Image.asset(
                  imgPath,
                  fit: BoxFit.cover,
                )
              : CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: imgPath,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/icon/default _profile.png',
                    fit: BoxFit.cover,
                  ),
                ),
    );
  }
}

class SelectableAvatar extends Avatar {
  const SelectableAvatar({
    required super.imgPath,
    required super.maxRadius,
    required this.isSelected,
    required this.ontap,
    super.key,
  });
  final bool isSelected;
  final VoidCallback ontap;

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
                  const BoxShadow(
                    color: Color.fromRGBO(181, 181, 181, 0.7),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Opacity(
          opacity: isSelected ? 1.0 : 0.7,
          child: Avatar(imgPath: imgPath, maxRadius: maxRadius),
        ),
      ),
    );
  }
}

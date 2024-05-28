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
}

class Avatar extends StatelessWidget {
  const Avatar({
    required this.imgPath,
    required this.maxRadius,
    this.isNetworkImage = false,
    super.key,
  });
  factory Avatar.fromSize({
    bool isnetworkImage = false,
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
    }
    return Avatar(
      imgPath: imgPath,
      maxRadius: radius,
      isNetworkImage: isNetworkImage,
    );
  }
  final String imgPath;
  final double maxRadius;
  final bool isNetworkImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: maxRadius * 2,
      width: maxRadius * 2,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: imgPath == ''
              ? const DecorationImage(
                  image: AssetImage('assets/icon/default _profile.png'))
              : null),
      child: imgPath == ''
          ? null
          : ClipRRect(
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: imgPath,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
                
                errorWidget: (context, url, error) =>
                    Image.asset('assets/icon/default _profile.png'),
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
    final imageProvider = isNetworkImage
        ? NetworkImage(imgPath) as ImageProvider
        : imgPath.isNotEmpty
            ? AssetImage(imgPath)
            : const AssetImage('assets/icon/default _profile.png');
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
          child: CircleAvatar(
            maxRadius: maxRadius, backgroundImage: imageProvider,
            // backgroundImage: NetworkImage(imgPath),
          ),
        ),
      ),
    );
  }
}

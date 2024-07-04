import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/env.dart';

class BannerImageComponent extends StatelessWidget {
  const BannerImageComponent({
    required this.imageUrl,
    this.height = 240.0,
    this.width,
    super.key,
  });

  final String imageUrl;
  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimension.d2),
      child: CachedNetworkImage(
        width: double.infinity,
        fit: BoxFit.cover,
        useOldImageOnUrlChange: true,
        imageUrl: '${Env.serverUrl}$imageUrl',
        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
          child: CircularProgressIndicator(
            value: downloadProgress.progress,
            color: AppColors.primary,
          ),
        ),
        errorWidget: (context, url, error) => const SizedBox(),
      ),
    );
  }
}

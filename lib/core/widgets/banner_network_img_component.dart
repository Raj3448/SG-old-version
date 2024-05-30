import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/env.dart';

class BannerImageComponent extends StatelessWidget {
  const BannerImageComponent({
    required this.imageUrl,
  });

  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimension.d2),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl:
            '${Env.serverUrl}$imageUrl',
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => const SizedBox(),
      ),
    );
  }
}
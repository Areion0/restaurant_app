import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../theme/theme_model.dart';
import '../loader.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String imageUrl;

  final BorderRadius? borderRadius;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CustomCachedNetworkImage({
    required this.imageUrl,
    this.borderRadius,
    this.fit,
    this.placeholder,
    this.errorWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(20),
      child: CachedNetworkImage(
        cacheManager: CacheManager(
          Config(
            'productPhotosCache',
            stalePeriod: const Duration(days: 7),
            maxNrOfCacheObjects: 100,
          ),
        ),
        fit: fit ?? BoxFit.cover,
        imageUrl: imageUrl,
        placeholder: (context, url) =>
            placeholder ??
            const Center(
              child: Loader(
                color: ThemeModel.darkBlue,
              ),
            ),
        errorWidget: (context, url, error) =>
            errorWidget ??
            const Icon(
              Icons.error,
              size: 40,
            ),
      ),
    );
  }
}

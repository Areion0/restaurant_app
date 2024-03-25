import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/theme_model.dart';

class ImageButton extends StatelessWidget {
  final Function()? onTap;
  final String imageUrl;

  const ImageButton({super.key, required this.onTap, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      splashColor: ThemeModel.darkBlue,
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
        ),
      ),
    );
  }
}

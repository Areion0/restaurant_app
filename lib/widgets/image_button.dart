import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/theme_model.dart';

class ImageButton extends StatelessWidget {
  final Function()? onTap;
  final String imageUrl;

  const ImageButton({super.key, required this.onTap, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 110,
          width: 130,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: imageUrl,
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            splashColor: ThemeModel.darkBlue.withOpacity(0.2),
            onTap: onTap,
            child: Ink(),
          ),
        ),
      ],
    );
  }
}

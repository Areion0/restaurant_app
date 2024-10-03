import 'package:flutter/material.dart';
import 'package:restaurant_app/widgets/photos/custom_cached_network_image.dart';

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
          child: CustomCachedNetworkImage(imageUrl: imageUrl),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            splashColor: ThemeModel.darkBlue.withOpacity(0.1),
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}

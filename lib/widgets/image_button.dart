import 'package:flutter/material.dart';

import '../theme/theme_model.dart';

class ImageButton extends StatelessWidget {
  final Function()? onTap;
  final String? imageUrl;
  const ImageButton({super.key, this.onTap, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        splashColor: ThemeModel.darkBlue,
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(color: ThemeModel.darkGrey),
        ),
      ),
    );
  }
}

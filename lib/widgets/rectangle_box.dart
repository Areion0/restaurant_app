import 'package:flutter/material.dart';
import 'package:restaurant_app/misc/extensions.dart';

import '../theme/theme_model.dart';

class RectangleBox extends StatelessWidget {
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Widget? child;

  const RectangleBox(
      {this.height, this.width, this.padding = const EdgeInsets.all(15), this.color, this.child, super.key});

  @override
  Widget build(BuildContext context) => Container(
        height: height ?? context.screenSize.height * 0.13,
        width: width,
        padding: padding,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: color ?? ThemeModel.lightGrey),
        child: child,
      );
}

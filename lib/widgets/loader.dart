import 'package:flutter/material.dart';

import '../theme/theme_model.dart';

class Loader extends CircularProgressIndicator {
  const Loader({
    super.key,
    super.strokeWidth = 5,
    super.value,
    super.backgroundColor,
    super.color = ThemeModel.lightGrey,
    super.valueColor,
  });
}

class LoaderWithLabel extends StatelessWidget {
  final String text;
  final double strokeWidth;
  final double? value;
  final Color? backgroundColor;
  final Color? color;
  final Animation<Color?>? valueColor;

  const LoaderWithLabel({
    this.text = "",
    this.strokeWidth = 5,
    this.value,
    this.backgroundColor,
    this.color = ThemeModel.lightGrey,
    this.valueColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Loader(
            strokeWidth: strokeWidth,
            value: value,
            backgroundColor: backgroundColor,
            color: color,
            valueColor: valueColor,
          ),
          const SizedBox(height: 10),
          Text(text, style: ThemeModel.theme.textTheme.bodyMedium),
        ],
      );
}

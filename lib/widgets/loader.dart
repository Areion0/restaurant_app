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

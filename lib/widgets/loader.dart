import 'package:flutter/material.dart';

class Loader extends CircularProgressIndicator {
  const Loader({
    super.key,
    super.strokeWidth = 5, // Default stroke width
    super.value,
    super.backgroundColor,
    super.color,
    super.valueColor,
  });
}

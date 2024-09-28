import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../theme/theme_model.dart';

class GalleryType {
  final String id;
  final String title;
  final Widget icon;

  const GalleryType._(this.id, this.title, this.icon);

  static const GalleryType recentOrders = GalleryType._(
    "recentOrders",
    "Recent Orders",
    Icon(
      Icons.shopping_bag_outlined,
      color: ThemeModel.darkBlue,
      size: 26,
    ),
  );
  static GalleryType mostPopular = GalleryType._("mostPopular", "Most Popular", emojiWrapper("🔥"));
  static GalleryType justAdded = GalleryType._("justAdded", "Just Added", emojiWrapper("✨"));
  static GalleryType recommended = GalleryType._("recommended", "Recommended", emojiWrapper("👇"));

  static emojiWrapper(String emoji) => Text(emoji, style: const TextStyle(fontSize: 20));

  static List<GalleryType> values = [
    recentOrders,
    mostPopular,
    justAdded,
    recommended,
  ];

  static GalleryType? fromName(String name) => values.firstWhereOrNull((gallery) => gallery.id == name);
}

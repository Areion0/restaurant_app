import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../theme/theme_model.dart';

class GalleryType {
  final String id;
  final String title;
  final Widget icon;
  final int order;

  const GalleryType._(this.id, this.title, this.icon, this.order);

  static const GalleryType recentOrders = GalleryType._(
    "recentOrders",
    "Recent Orders",
    Icon(
      Icons.shopping_bag_outlined,
      color: ThemeModel.darkBlue,
      size: 26,
    ),
    0,
  );
  static GalleryType favorites =
      GalleryType._("favorites", "Favorites", emojiWrapper("❤️", color: ThemeModel.lightRed), 1);
  static GalleryType mostPopular = GalleryType._("mostPopular", "Most Popular", emojiWrapper("🔥"), 2);
  static GalleryType justAdded = GalleryType._("justAdded", "Just Added", emojiWrapper("✨"), 3);
  static GalleryType recommended = GalleryType._("recommended", "Recommended", emojiWrapper("👇"), 4);

  static emojiWrapper(String emoji, {Color? color}) => Text(emoji, style: TextStyle(fontSize: 20, color: color));

  static List<GalleryType> values = [
    recentOrders,
    favorites,
    mostPopular,
    justAdded,
    recommended,
  ];

  static GalleryType? fromName(String name) => values.firstWhereOrNull((gallery) => gallery.id == name);
}

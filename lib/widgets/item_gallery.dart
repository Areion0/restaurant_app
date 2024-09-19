import 'package:flutter/material.dart';
import 'package:restaurant_app/theme/theme_model.dart';
import 'package:restaurant_app/widgets/image_button.dart';

import 'loader.dart';

class ItemGallery extends StatelessWidget {
  final String title;
  final Widget? prefix;
  final List<ImageButton> items;
  final bool fetching;
  const ItemGallery({
    required this.title,
    this.prefix,
    required this.items,
    this.fetching = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            prefix ?? Container(),
            // Title
            const SizedBox(width: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Image Buttons
        Container(
          height: 120,
          child: fetching
              ? const Center(child: Loader(color: ThemeModel.darkBlue))
              : items.isEmpty
                  ? const Center(
                      child: Text(
                        "No items found",
                        style: TextStyle(
                          color: ThemeModel.darkGrey,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Container(width: 140, child: items[index]);
                      },
                    ),
        )
      ],
    );
  }
}

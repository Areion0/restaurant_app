import 'package:flutter/material.dart';

import '../theme/theme_model.dart';

class ItemGallery extends StatelessWidget {
  final String title;
  final Widget? prefix;
  final List items;
  const ItemGallery({required this.title, this.prefix, required this.items, super.key});

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
          child: items.length == 1
              ? Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(height: 100, color: ThemeModel.darkGrey),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(width: 120, color: ThemeModel.darkGrey),
                      ),
                    );
                  },
                ),
        )
      ],
    );
  }
}

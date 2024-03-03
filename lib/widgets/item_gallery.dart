import 'package:flutter/material.dart';
import 'package:restaurant_app/widgets/image_button.dart';

class ItemGallery extends StatelessWidget {
  final String title;
  final Widget? prefix;
  final List<ImageButton> items;
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
              ? items[0]
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

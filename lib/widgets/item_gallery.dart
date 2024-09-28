import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:restaurant_app/misc/extensions.dart';
import 'package:restaurant_app/models/product_gallery.dart';
import 'package:restaurant_app/theme/theme_model.dart';
import 'package:restaurant_app/widgets/image_button.dart';

import '../product/product_page.dart';

class ItemGallery extends StatefulWidget {
  final ProductGallery gallery;
  const ItemGallery({
    required this.gallery,
    super.key,
  });

  @override
  State<ItemGallery> createState() => _ItemGalleryState();
}

class _ItemGalleryState extends State<ItemGallery> {
  List<ImageButton> productButtons = [];

  @override
  void initState() {
    super.initState();

    productButtons = widget.gallery.products
        .map((product) => ImageButton(
              imageUrl: product.imageURL ?? "",
              onTap: () => context.push(ProductPage(product: product)),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            widget.gallery.type.icon,
            const Gap(5),
            // Title
            Text(
              widget.gallery.type.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const Gap(10),

        // Image Buttons
        Container(
          height: 120,
          child: widget.gallery.products.isEmpty
              ? Center(
                  child: Text(
                    "No items found",
                    style: ThemeModel.theme.textTheme.bodyLarge!.copyWith(
                      color: ThemeModel.darkGrey,
                    ),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.gallery.products.length,
                  itemBuilder: (context, index) {
                    return Container(width: 140, child: productButtons[index]);
                  },
                ),
        )
      ],
    );
  }
}

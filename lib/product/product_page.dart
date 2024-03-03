import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/misc/extensions.dart';
import 'package:restaurant_app/widgets/custom_appbar.dart';
import 'package:restaurant_app/widgets/image_button.dart';
import 'package:restaurant_app/widgets/item_gallery.dart';
import 'package:restaurant_app/widgets/page_blueprint.dart';

import '../models/product.dart';
import '../theme/theme_model.dart';

class ProductPage extends StatefulWidget {
  final Product product;
  const ProductPage({required this.product, super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool favorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
          icon: Icon(
            favorite ? Icons.favorite : Icons.favorite_border,
            color: ThemeModel.darkRed,
          ),
          title: Text(
            widget.product.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            setState(() {
              favorite = !favorite;
            });
          }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PageBlueprint(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // Content
                  Column(
                    children: [
                      // Image
                      widget.product.imageURL == null
                          ? const CircularProgressIndicator()
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(imageUrl: widget.product.imageURL!)),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: widget.product.description,
                              style: const TextStyle(
                                  color: ThemeModel.darkBlue, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),

                      // Add to cart
                      Container(
                        height: 65,
                        width: context.mediaQuery.size.width * 0.6,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: RichText(
                            text: TextSpan(
                              text: "Add To Cart",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.normal, color: ThemeModel.lightGrey),
                              children: [
                                TextSpan(
                                  text: " € ${widget.product.price}",
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ],
              ),
            ),
            // Similar products
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: ItemGallery(
                title: "Combine With 🍗 + 🥗",
                items: List.generate(
                    3,
                    (index) => ImageButton(
                          imageUrl: "https://via.placeholder.com/150",
                          onTap: () {},
                        )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

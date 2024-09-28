import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/misc/extensions.dart';
import 'package:restaurant_app/widgets/custom_appbar.dart';
import 'package:restaurant_app/widgets/image_button.dart';
import 'package:restaurant_app/widgets/item_gallery.dart';
import 'package:restaurant_app/widgets/page_blueprint.dart';

import '../cart/cart_item.dart';
import '../models/product.dart';
import '../theme/theme_model.dart';
import '../widgets/loader.dart';

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
            style: ThemeModel.theme.textTheme.titleMedium,
          ),
          onIconPressed: () {
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
                          ? const Loader()
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

                      // TODO: Replace with new button that increments/decrements the quantity in cart
                      // Animates between ["Add to cart"] <-> [- "1" +]
                      // Add to cart
                      Container(
                        height: 65,
                        width: context.screenSize.width * 0.6,
                        child: ElevatedButton(
                          onPressed: () {
                            context.cartController.add(CartItem(product: widget.product));
                            context.pop();
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Add To Cart",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontSize: 22, fontWeight: FontWeight.normal, color: ThemeModel.lightGrey),
                              children: [
                                TextSpan(
                                  text: " € ${widget.product.price}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(fontSize: 22, color: ThemeModel.lightGrey),
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
            // TODO: Similar products
            // Padding(
            //   padding: const EdgeInsets.only(left: 20),
            //   child: ItemGallery(
            //     title: "Combine With 🍗 + 🥗",
            //     gallery: List.generate(
            //         3,
            //         (index) => ImageButton(
            //               imageUrl: "https://via.placeholder.com/150",
            //               onTap: () {},
            //             )),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

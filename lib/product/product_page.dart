import 'package:flutter/material.dart';
import 'package:restaurant_app/misc/extensions.dart';
import 'package:restaurant_app/product/appbar.dart';
import 'package:restaurant_app/widgets/image_button.dart';
import 'package:restaurant_app/widgets/item_gallery.dart';
import 'package:restaurant_app/widgets/page_blueprint.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageBlueprint(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const ProductAppbar(),

          const SizedBox(height: 20),

          // Content
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Column(
              children: [
                // Image
                Container(height: 200, child: const ImageButton()),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Description
                      Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec euismod, nisl eget ultricies aliquam, nunc nisl aliquet nunc, vitae aliquam nisl nunc eu nisl. ",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Donec euismod, nisl eget ultricies aliquam, nunc nisl aliquet nunc, vitae aliquam nisl nunc eu nisl.",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Donec euismod, nisl eget ultricies aliquam, nunc nisl aliquet nunc, vitae aliquam nisl nunc eu nisl.",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Price
                Text(
                  "€ 7.50",
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 20),

                // Add to cart
                Container(
                  height: 65,
                  width: context.mediaQuery.size.width * 0.6,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Add To Cart"),
                  ),
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
          // Similar products
          const ItemGallery(
            title: "Combine With 🍗 + 🥗",
            items: ["", "", "", ""],
          )
        ],
      )),
    );
  }
}

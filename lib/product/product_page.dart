import 'package:flutter/material.dart';
import 'package:restaurant_app/product/appbar.dart';
import 'package:restaurant_app/widgets/image_button.dart';
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
          child: Padding(
        padding: const EdgeInsets.only(right: 10),
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

                  // Description
                  Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec euismod, nisl eget ultricies aliquam, nunc nisl aliquet nunc, vitae aliquam nisl nunc eu nisl. Donec euismod, nisl eget ultricies aliquam, nunc nisl aliquet nunc, vitae aliquam nisl nunc eu nisl."),

                  // Price

                  // Add to cart

                  // Reviews

                  // Similar products
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}

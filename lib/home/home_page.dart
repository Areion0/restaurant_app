import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:restaurant_app/firebase/firestore_controller.dart';
import 'package:restaurant_app/misc/extensions.dart';
import 'package:restaurant_app/widgets/custom_appbar.dart';
import 'package:restaurant_app/widgets/item_gallery.dart';
import 'package:restaurant_app/widgets/page_blueprint.dart';

import '../cart/cart_view.dart';
import '../models/product.dart';
import '../product/product_page.dart';
import '../theme/theme_model.dart';
import '../widgets/image_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool firstTime = true;

  List<Product> products = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (firstTime) {
      firstTime = false;

      products = await FirestoreController.getProducts();
      items = await Future.wait(
        products.map(
          (product) async {
            return ImageButton(
              imageUrl: product.imageURL ?? "",
              onTap: () => context.push(
                ProductPage(product: product),
              ),
            );
          },
        ),
      );
      setState(() {});

      Logger logger = Logger();

      for (var product in products) {
        logger.i(product.toMap().pretty);
      }
    }
  }

  List<String> titles = [
    "Recent Orders",
    "Most Popular",
    "Just Added",
    "Recommended",
  ];

  List<Widget> prefixes = const [
    Icon(
      Icons.shopping_bag_outlined,
      color: ThemeModel.darkBlue,
      size: 26,
    ),
    Text(
      "🔥",
      style: TextStyle(fontSize: 20),
    ),
    Text(
      "✨",
      style: TextStyle(fontSize: 20),
    ),
    Text(
      "👇",
      style: TextStyle(fontSize: 20),
    ),
  ];

  List<ImageButton> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  log('Profile Image Tapped');
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ThemeModel.darkGrey,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(50),
                    color: ThemeModel.darkBlue,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'John',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Doe',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          icon: const Icon(
            Icons.shopping_cart_outlined,
            size: 35,
          ),
          onPressed: () => context.push(const CartView()),
        ),
        body: PageBlueprint(
          isHome: true,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                height: context.mediaQuery.size.height * 0.85,
                child:
                    // ListView.separated(
                    // itemCount: items.length,
                    // itemBuilder: (context, index) =>
                    ItemGallery(
                  title: titles[0],
                  prefix: prefixes[0],
                  items: items,
                ),
                // separatorBuilder: (context, index) => const SizedBox(height: 30),
                // ),
              ),
            ],
          ),
        ));
  }
}

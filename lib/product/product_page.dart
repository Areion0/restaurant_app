import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/auth/auth_controller.dart';
import 'package:restaurant_app/firebase/firestore_controller.dart';
import 'package:restaurant_app/misc/extensions.dart';
import 'package:restaurant_app/models/user_model.dart';
import 'package:restaurant_app/widgets/custom_appbar.dart';
import 'package:restaurant_app/widgets/page_blueprint.dart';
import 'package:restaurant_app/widgets/photos/custom_cached_network_image.dart';

import '../models/product.dart';
import '../theme/theme_model.dart';
import '../widgets/buttons/quantity_button.dart';
import '../widgets/loader.dart';

class ProductPage extends StatefulWidget {
  final Product product;
  const ProductPage({required this.product, super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool favoriteLoading = false;
  bool get favorite => context.authController.user!.favorites.contains(widget.product.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
          icon: Selector<AuthController, UserModel>(
              selector: (context, authController) => authController.user!,
              builder: (context, user, child) {
                return Container(
                    height: 30,
                    width: 30,
                    child: favoriteLoading
                        ? const Center(
                            child: Loader(
                              color: ThemeModel.darkBlue,
                            ),
                          )
                        : Icon(
                            favorite ? Icons.favorite : Icons.favorite_border,
                            color: ThemeModel.darkRed,
                          ));
              }),
          title: Text(
            widget.product.name,
            style: ThemeModel.theme.textTheme.titleMedium,
          ),
          onIconPressed: () async {
            if (favoriteLoading) return;

            setState(() {
              favoriteLoading = true;
            });
            if (favorite) {
              await FirestoreController.removeFromFavorites(context, productID: widget.product.id);
            } else {
              await FirestoreController.addToFavorites(context, productID: widget.product.id);
            }

            if (context.mounted) await context.authController.refreshUserData();

            if (mounted) setState(() => favoriteLoading = false);
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
                          : CustomCachedNetworkImage(imageUrl: widget.product.imageURL!),

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
                          width: context.screenSize.width * 0.6,
                          child: QuantityButton(
                            product: widget.product,
                          )),

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

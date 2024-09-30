import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/misc/extensions.dart';

import '../models/product.dart';
import '../theme/theme_model.dart';
import '../widgets/rectangle_box.dart';
import 'cart_controller.dart';

class CartItemCompact extends StatelessWidget {
  final Product product;
  const CartItemCompact({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double width = context.screenSize.width * 0.75;
    double height = context.screenSize.height * 0.08;

    return Center(
      child: RectangleBox(
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FittedBox(
              child: Container(
                height: width * 0.25,
                width: width * 0.25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ThemeModel.darkBlue,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Container(
                  width: width * 0.45,
                  child: Text(
                    product.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(color: ThemeModel.darkBlue, fontSize: 16),
                  ),
                ),

                const SizedBox(),

                // Description
                Container(
                  width: width * 0.45,
                  child: Text(
                    product.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(color: ThemeModel.darkGrey, fontSize: 12),
                  ),
                )
              ],
            ),

            const SizedBox(),

            // Quantity and Price
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Quantity
                Selector<CartController, int>(
                    selector: (context, cart) => cart.items
                        .where(
                          (element) => element.id == product.id,
                        )
                        .length,
                    builder: (context, quantity, child) => Text("x$quantity")),

                // Price
                Text("€ ${product.price}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/misc/extensions.dart';
import 'package:restaurant_app/theme/theme_model.dart';
import 'package:restaurant_app/widgets/rectangle_box.dart';

import '../models/product.dart';
import 'cart_controller.dart';

class CartItem extends StatelessWidget {
  final Product product;
  const CartItem({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    double width = context.mediaQuery.size.width * 0.75;

    return Center(
      child: RectangleBox(
        height: context.mediaQuery.size.height * 0.13,
        width: width,
        child: Row(
          children: [
            Container(
              width: width * 0.25,
              height: width * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ThemeModel.darkBlue,
              ),
            ),
            SizedBox(width: width * 0.05),
            Container(
              width: width * 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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

                          // Description
                          Container(
                            width: width * 0.45,
                            child: Text(
                              product.description,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(color: ThemeModel.darkGrey, fontSize: 12),
                            ),
                          )
                        ],
                      ),

                      // Remove button
                      Container(
                        height: 35,
                        width: 35,
                        child: IconButton(
                          onPressed: () {
                            context.read<CartController>().remove(this);
                            if (context.read<CartController>().items.isEmpty) context.pop();
                          },
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: ThemeModel.darkRed,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Quantity
                        const Text("x1"),

                        // Price
                        Text("\$ ${product.price}"),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/cart/cart_controller.dart';
import 'package:restaurant_app/misc/extensions.dart';

import '../../models/product.dart';
import '../../theme/theme_model.dart';

class QuantityButton extends StatefulWidget {
  final Product product;
  const QuantityButton({required this.product, super.key});

  @override
  State<QuantityButton> createState() => _QuantityButtonState();
}

class _QuantityButtonState extends State<QuantityButton> with TickerProviderStateMixin {
  late CartController cartController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    cartController = context.watch<CartController>();
  }

  bool get productInCart => cartController.items.any(
        (product) => product.id == widget.product.id,
      );

  double get addToCartOpacity {
    if (productInCart) return 0.0;
    return 1.0;
  }

  double get quantitySelectorOpacity {
    if (productInCart) return 1.0;
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Quantity Selector
        IgnorePointer(
          ignoring: quantitySelectorOpacity < 1,
          child: AnimatedOpacity(
            opacity: quantitySelectorOpacity,
            duration: const Duration(milliseconds: 300),
            child: Container(
              height: 65,
              width: context.screenSize.width * 0.65,
              decoration: BoxDecoration(color: ThemeModel.darkRed, borderRadius: BorderRadius.circular(14)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Container(
                      height: 40,
                      width: 40,
                      child: Material(
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              if (!productInCart) return;

                              cartController.removeProduct(widget.product);
                            },
                            child: const Icon(
                              Icons.remove,
                              color: ThemeModel.darkBlue,
                            )),
                      ),
                    ),
                  ),
                  Text(
                    cartController.quantityOfProduct(widget.product).toString(),
                    style: ThemeModel.theme.textTheme.titleMedium?.copyWith(color: ThemeModel.lightGrey),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Container(
                      height: 40,
                      width: 40,
                      child: Material(
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () => cartController.addProduct(widget.product),
                            child: const Icon(
                              Icons.add,
                              color: ThemeModel.darkBlue,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        IgnorePointer(
          ignoring: addToCartOpacity < 1,
          child: AnimatedOpacity(
            opacity: addToCartOpacity,
            duration: const Duration(milliseconds: 300),
            child: Container(
              height: 65,
              width: context.screenSize.width * 0.65,
              child: ElevatedButton(
                onPressed: () {
                  if (productInCart) return;

                  cartController.addProduct(widget.product);
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
                        style:
                            Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 22, color: ThemeModel.lightGrey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
